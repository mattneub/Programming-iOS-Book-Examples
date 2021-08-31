

import UIKit

// illustrating MainActor.run

actor MyActor {
    func f() {
        print("f", Thread.isMainThread)
    }
    nonisolated func g() {
        print("g", Thread.isMainThread)
    }
}

class ViewController: UIViewController {
    func yoho() {
        print("yoho", Thread.isMainThread)
    }
    var which = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let act = MyActor()
        act.g()
        print("---")
        switch which {
        case 0:
            Task {
                await act.f()
                print("---")
                act.g()
                print("---")
                await MainActor.run { act.g() }
                print("---")
                await MainActor.run { self.yoho() }
            }
        case 1:
            Task.detached {
                await act.f()
                print("---")
                act.g()
                print("---")
                await MainActor.run { act.g() }
                print("---")
                await MainActor.run { self.yoho() }
            }
        default: break
        }

    }
}
