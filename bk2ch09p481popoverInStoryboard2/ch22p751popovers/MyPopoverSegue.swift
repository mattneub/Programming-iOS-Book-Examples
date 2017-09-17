

import UIKit

class MyPopoverSegue: UIStoryboardSegue {
    override func perform() {
        let dest = self.destination
        if let pop = dest.popoverPresentationController {
            // pop.delegate = self
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
