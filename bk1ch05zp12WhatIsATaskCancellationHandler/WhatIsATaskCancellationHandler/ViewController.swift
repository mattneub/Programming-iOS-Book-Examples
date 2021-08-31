

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

struct MyError : Error {}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let waiter = Waiter()
        
        // a task on which a cancellation handler is installed
        let waitTask = Task {
            await withTaskCancellationHandler {
                await waiter.wait(2) // executed _now_
            } onCancel: {
                print("yipes")
                // observe that we cannot respond to cancellation by throwing in the handler!
                // it's not a throwing function
//                throw MyError()
                // so all you can really do is clean up somehow
            }
            await waiter.wait(1)
        }
        
        // the result is that that the cancellation handler is called immediately
        // when we cancel the task
        Task {
            await Task.sleep(0.1)
            print("trying to cancel")
            waitTask.cancel()
        }
    }


}

