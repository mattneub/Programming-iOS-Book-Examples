

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


extension Task where Success == Never, Failure == Never {
    static func sleep(_ seconds:Double) async {
        await self.sleep(UInt64(seconds * 1_000_000_000))
    }
    static func sleepThrowing(_ seconds:Double) async throws {
        try await self.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}

enum MyError : Error {
    case oops
}

actor Waiter {
    private var randSecs : Double { Double.random(in: 1...3) }
    func wait(_ i:Int) async {
        print("wait start", i)
        print("inner task cancelled? start", i, Task.isCancelled)
        await Task.sleep(randSecs)
        print("inner task cancelled? end", i, Task.isCancelled)
        print("wait end", i)
    }
    func waitAndCancel(_ i:Int) async {
        print("wait start", i)
        print("inner task cancelled? start", i, Task.isCancelled)
        await Task.sleep(0.1)
        withUnsafeCurrentTask { t in
            if let t = t {
                print("inner task is cancelling itself", i)
                t.cancel()
            }
        }
        await Task.sleep(randSecs)
        print("inner task cancelled? end", i, Task.isCancelled)
        print("wait end", i)
    }
    func waitAndThrow(_ i:Int) async throws {
        print("wait start", i)
        print("inner task cancelled? start", i, Task.isCancelled)
        print("inner task throwing", i)
        throw MyError.oops
        await Task.sleep(randSecs)
        print("inner task cancelled? end", i, Task.isCancelled)
        print("wait end", i)
    }

    func waitThrowing(_ i:Int) async throws {
        print("wait start", i)
        do {
            try await Task.sleepThrowing(randSecs)
        } catch {
            print("wait throwing", i)
            throw error
        }
        print("wait end", i)
    }
}

var which = 3 // 0 thru 4, except 2 which is a failed experiment

class ViewController: UIViewController {
    let waiter = Waiter()
    override func viewDidLoad() {
        super.viewDidLoad()
        switch which {
        case 0: doesOuterCancelInner()
        case 1: doesInnerCancelOuter()
        case 2:
            // ignore this one
            break;
            Task {
                try await doesThrowingOuterCancelInner()
            }
        case 3:
            Task {
                try await doesThrowingInnerCancelOuter()
            }
        case 4:
            Task {
                try await unawaitedAsyncLet()
            }
        default: break
        }
        
    }
    
    // proving that cancelling the main task cancels the task group subtasks
    // in this example, cancelling does _do_ anything; we're just showing
    // that the cancel call percolates down the tree
    func doesOuterCancelInner() {
        let task = Task {
            print("outer task cancelled?", Task.isCancelled)
            await withTaskGroup(of: Void.self) { group in
                group.addTask {
                    await self.waiter.wait(1)
                }
                group.addTask {
                    await self.waiter.wait(2)
                }
                for await _ in group {}
            }
            print("outer task cancelled?", Task.isCancelled)
        }
        Task {
            await Task.sleep(0.3)
            print("I will cancel outer")
            task.cancel()
        }
    }
    
    // proving that cancel on a task group subtask doesn't affect any other task
    // (it would affect that subtask's subtasks if it had any, of course)
    func doesInnerCancelOuter() {
        Task {
            print("outer task cancelled?", Task.isCancelled)
            await withTaskGroup(of: Void.self) { group in
                group.addTask {
                    await self.waiter.waitAndCancel(1)
                }
                group.addTask {
                    await self.waiter.wait(2)
                }
                for await _ in group {}
            }
            print("outer task cancelled?", Task.isCancelled)
        }
    }
    
    // proving that throwing from the main task doesn't affect the task group subtasks
    // NO, I couldn't find a way to test this!
    // can't throw _while_ the task group is waiting, because we too are waiting :) hahaha
    func doesThrowingOuterCancelInner() async throws {
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.waiter.wait(1)
            }
            group.addTask {
                await self.waiter.wait(2)
            }
            for await _ in group {}
        }
        print("outer task is about to throw")
        throw MyError.oops
        print("outer task cancelled?", Task.isCancelled)
    }
    
    // proving that throwing from a task group subtask cancels the other subtasks
    // it doesn't cancel the outer task but it can be allowed to percolate up and rethrow
    func doesThrowingInnerCancelOuter() async throws {
        print("outer task cancelled?", Task.isCancelled)
        try await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask {
                await Task.sleep(0.1)
                try await self.waiter.waitAndThrow(1)
            }
            group.addTask {
                await self.waiter.wait(2)
            }
            // we _have_ to "collect" the group tasks in order to rethrow
            // observe that if you comment out this next line, the other subtask isn't cancelled
            // in other words, it is the throw passing thru the task _group_ that cancels the other subtasks!
            // In fact, if you uncomment the next line, both subtasks are cancelled
            // this proves that the mechanism is not the subtask throwing but the task group throwing
            // throw MyError.oops
            
            // I also tested to make sure that it isn't the mere processing by the `for try await` that does it
//            do {
            for try await _ in group {}
//            } catch {
//                print("yoho")
//            }
        }
//        async let one = await self.waiter.waitAndThrow(1)
//        async let two = await self.waiter.wait(2)
//        await Task.sleep(2.0)
//        let outcome = (try await one, try await two)
        
        // this isn't printed because we rethrow...
        // but change our `try` to `try?` and you'll see we are not cancelled
        print("outer task cancelled?", Task.isCancelled)
    }
    
    // when an async let tasks throws
    // there is _no_ automatic cancellation of other async let tasks,
    // because there is no task group controlling everything
    // however, there is another mechanism:
    // if you don't say `await` on a pending async let task,
    // that task is cancelled and awaited anyway
    // and if you rethrow, then of course you don't get a chance to say `await`
    func unawaitedAsyncLet() async throws {
        print("outer task cancelled?", Task.isCancelled)
        async let one: Void = self.waiter.waitAndThrow(1)
        async let two: Void = self.waiter.wait(2)
        await Task.sleep(0.1)
        print("I will try to await 1")
        _ = try await one
        print("I have just tried to await 1")
        await Task.sleep(0.1)
        print("I will try to await 2")
        _ = await two
        
        // this isn't printed because we rethrow
        print("outer task cancelled?", Task.isCancelled)
    }


}

