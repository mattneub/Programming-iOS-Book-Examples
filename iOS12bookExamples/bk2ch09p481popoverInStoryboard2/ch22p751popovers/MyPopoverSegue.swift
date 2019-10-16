

import UIKit

class MyPopoverSegue: UIStoryboardSegue {
    override func perform() {
        let dest = self.destination
        if let pop = dest.popoverPresentationController {
            // pop.delegate = self
        }
        super.perform()
        CATransaction.setCompletionBlock {
            let dest = self.destination
            if let pop = dest.popoverPresentationController {
                pop.passthroughViews = nil
            }
        }
    }
}

// I tried making _this_ the popover delegate...
// the adaptive methods are called,
// but, disappointingly, the dismissal methods weren't called
// (I guess because the segue is no longer in existence)
// I think I regard that as a bug; if I can't encapsulte this stuff,
// what's the point of the custom segue?

extension MyPopoverSegue : UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        print("here3a")
        if traitCollection.horizontalSizeClass == .compact {
            return .fullScreen
        }
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        print("here4a")
    }
    
}
