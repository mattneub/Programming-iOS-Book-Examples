
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
    func wait1(_ i:Int) async {
        print("starting wait1", i)
        await Task.sleep(1.0)
        print("middle wait1", i)
        await Task.sleep(1.0)
        print("end wait1", i)
    }
    func wait2(_ i:Int) async {
        print("starting wait2", i)
        await Task.sleep(1.0)
        print("middle wait2", i)
        await Task.sleep(1.0)
        print("end wait2", i)
    }
}

// proving that an actor is reentrant, even on the very same method

class ViewController: UIViewController {
    let waiter = Waiter()
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await self.waiter.wait1(1)
        }
        Task {
            await Task.sleep(0.1)
            await self.waiter.wait1(2)
        }
        Task {
            await Task.sleep(0.2)
            await self.waiter.wait2(3)
        }
    }


}

