

import UIKit

class ViewController2: UIViewController, UIPopoverPresentationControllerDelegate {
    
    // showing how behavior of modalInPopover for presented-inside-popover has changed from iOS 7

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("prepare") // make sure we're called
        let dest = segue.destinationViewController as! UIViewController
        dest.modalInPopover = true  // does nothing
        self.modalInPopover = true // desperate, still does nothing
        if let pop = self.popoverPresentationController {
            println("del")
            pop.delegate = self // comment out this line to see what happens without the workaround
        }
    }
    
    // and here's how to work around it
    // (you could argue that this is a better way in any case, I suppose)
    
    func popoverPresentationControllerShouldDismissPopover(pop: UIPopoverPresentationController) -> Bool {
        let ok = pop.presentedViewController.presentedViewController == nil
        println(ok)
        return ok
    }

}
