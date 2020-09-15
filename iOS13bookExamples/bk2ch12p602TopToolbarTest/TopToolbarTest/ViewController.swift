

import UIKit

// proving that if you really want to, you can put a toolbar at the top
// even on an iPhone (works coherently even on iPhone X)

class ViewController: UIViewController, UIBarPositioningDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }

}

