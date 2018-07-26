

import UIKit

// run on a Plus, such as iPhone 8 Plus
// rotate the device / simulator and wait 2 seconds for output in the console

// what to notice: the split view controller does indeed jettison a child in portrait,
// but it doesn't _release_ it:
// `deinit` is never called, and the same detail view controller keeps returning in landscape

class ViewController: UIViewController {

    override func viewDidLayoutSubviews() {
        let s = self.splitViewController!
        print("did layout")
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            print(s.viewControllers)
        }
    }
    
    deinit {
        print("farewell from a child view controller")
    }

}

