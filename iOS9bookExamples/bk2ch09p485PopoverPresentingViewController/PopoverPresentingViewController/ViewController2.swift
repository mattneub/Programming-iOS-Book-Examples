

import UIKit

class ViewController2: UIViewController, UIPopoverPresentationControllerDelegate {
    
    // showing how behavior of modalInPopover for presented-inside-popover has changed from iOS 7

    let workaround = false
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let pop = self.popoverPresentationController {
            if workaround {
                print("del")
                pop.delegate = self
            }
        }
    }
    
    // and here's how to work around it
    // (you could argue that this is a better way in any case, I suppose)
    // works on iOS 9 and 8, restoring the iOS 7 behavior
    
    func popoverPresentationControllerShouldDismissPopover(pop: UIPopoverPresentationController) -> Bool {
        let ok = pop.presentedViewController.presentedViewController == nil
        print(ok)
        return ok
    }

}
