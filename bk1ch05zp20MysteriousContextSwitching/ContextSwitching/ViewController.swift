

import UIKit

// can anyone explain this weird behavior?

func test1() {
    print("test1", Thread.isMainThread) // true
    Task {
        print("test1 task", Thread.isMainThread) // false
    }
}

class ViewController: UIViewController {
    var which = 2 // try 1 or 2
    override func viewDidLoad() {
        super.viewDidLoad()
        switch which {
        case 1:
            test1()
            test2()
        case 2:
            test1()
            Task.detached {
                self.test2()
            }
        default: break
        }
    }

    func test2() {
        print("test2", Thread.isMainThread) // true
        Task {
            print("test2 task", Thread.isMainThread) // true, but false in case 2
        }
    }
}
