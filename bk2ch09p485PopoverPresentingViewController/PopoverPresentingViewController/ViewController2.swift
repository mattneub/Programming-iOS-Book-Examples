

import UIKit

class ViewController2: UIViewController, UIPopoverPresentationControllerDelegate {
    
    // showing how behavior of modalInPopover for presented-inside-popover has changed from iOS 7

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pop = self.popoverPresentationController {
            // ??? what was this for????
//            if let v = sender as? UIView {
//                pop.sourceView = v
//                pop.sourceRect = v.bounds
//            }
            
            var workaround : Bool { return true }
            if workaround {
                print("del")
                pop.delegate = self
            }
        }
    }
    
    // and here's how to work around it
    // (you could argue that this is a better way in any case, I suppose)
    // works on iOS 9 and 8, restoring the iOS 7 behavior
    
    func presentationControllerShouldDismiss(_ pc: UIPresentationController) -> Bool {
        print("shouldpc")
        return pc.presentedViewController.presentedViewController == nil
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ pop: UIPopoverPresentationController) -> Bool {
        print("shouldpop")
        return pop.presentedViewController.presentedViewController == nil
    }

}
