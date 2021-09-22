

import UIKit

class ViewController: UIViewController {
    var which = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        switch which {
        case 1, 2:
            Task.detached(priority: .userInitiated) {
                await self.test()
            }
        case 3:
            Task {
                await self.test2()
            }
        default: break
        }
    }
    @MainActor func getBounds() async -> CGRect {
        let bounds = self.view.bounds
        return bounds
    }
    func test() async {
        print("test 1", Thread.isMainThread) // false
        switch which {
        case 1:
            let bounds = await self.getBounds()
            print("test 2", Thread.isMainThread) // true
        case 2:
            async let bounds = self.getBounds()
            let thebounds = await bounds
            print("test 2", Thread.isMainThread) // true
        default: break
        }
    }
    nonisolated func test2() async {
        print("test 1", Thread.isMainThread) // false
        let bounds = await self.view.bounds // access on main thread!
        print("test 2", bounds, Thread.isMainThread) // false
    }

}

