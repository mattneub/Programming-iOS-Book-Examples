

import UIKit

import UIKit

extension Task where Success == Never, Failure == Never {
    static func sleep(_ seconds:Double) async {
        await self.sleep(UInt64(seconds * 1_000_000_000))
    }
    static func sleepThrowing(_ seconds:Double) async throws {
        try await self.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}

actor Waiter {
    private var randSecs : Double { Double.random(in: 1...3) }
    func wait(_ i:Int) async {
        print("wait start", i)
        await Task.sleep(randSecs)
        print("wait end", i)
    }
    func waitThrowing(_ i:Int) async throws {
        print("wait start", i)
        if i == 1 {print("throwing from", i); throw MyError()}
        await Task.sleep(randSecs) // but don't throw if cancelled
        print("wait end", i)
    }
}

struct MyError: Error {}

class ViewController: UIViewController {
    
    // in this example we just throw from a subtask, to see what happens at the top level
    // even though subtask 1 throws before subtask 2 even starts,
    // subtask 2 _does_ start and finishes in the normal way!
    // this shows that the throw does not percolate up to the main task
    // until _all_ subtasks have started and awaited
    // this is because of where we say `try await` for the results
    // if you move the r1 try earlier, then sure, that's where you hear about it
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let waiter = Waiter()
        Task {
            print("welcome to my task")
            do {
                print("my task starts waiting")
                async let result : Void = waiter.waitThrowing(1)
                await Task.sleep(0.5)
                // let r1 : () = try await result
                async let result2 : Void = waiter.waitThrowing(2)
                let r1 : () = try await result
                let r2 : () = try await result2
                print("my task finished waiting", r1, r2)
            } catch {
                print("hey, someone threw an error")
                throw error
            }
            print("I finished my task")
        }
    }


}


