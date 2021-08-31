

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
        do {
            try await Task.sleepThrowing(randSecs)
        } catch {
            print("wait throwing", i)
            throw error
        }
        print("wait end", i)
    }
}

struct MyError: Error {}

class ViewController: UIViewController {
    
    // proving that cancelling a task cancels its async let subtasks
    // to show this, we start two async let subtasks that call a method
    // that throws when cancelled
    // then we cancel the main task
    // both async let tasks throw
    
    // interestingly, if you cancel the main task before the second async let starts,
    // it still starts but it is "born cancelled"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let waiter = Waiter()
        let task = Task {
            print("welcome to my task")
            do {
                print("my task starts waiting")
                async let result : Void = waiter.waitThrowing(1)
                await Task.sleep(0.5)
                async let result2 : Void = waiter.waitThrowing(2)
                print("my task finished waiting", try await result, try await result2)
            } catch {
                print("hey, someone threw an error")
                throw error
            }
            print("I finished my task")
        }
        Task {
            await Task.sleep(0.2)
            print("cancel the main task")
            task.cancel()
        }
    }


}

