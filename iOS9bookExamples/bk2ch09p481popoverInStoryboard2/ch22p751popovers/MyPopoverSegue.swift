

import UIKit

class MyPopoverSegue: UIStoryboardSegue {
    override func perform() {
        let dest = self.destinationViewController
        if let pop = dest.popoverPresentationController {
            delay(0.1) {
                pop.passthroughViews = nil
            }
        }
        super.perform()
    }
}

// I tried making _this_ the popover delegate...
// the adaptive methods are called,
// but, disappointingly, the dismissal methods weren't called
// (I guess because the segue is no longer in existence)