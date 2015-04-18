
import UIKit
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class ViewController: UIViewController {
    

    @IBOutlet var toolbar : UIToolbar!
    
    @IBAction func doButton(sender:AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        func handler(act:UIAlertAction!) {
            println("User tapped \(act.title)")
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: handler)) // not shown
        alert.addAction(UIAlertAction(title: "Hey", style: .Default, handler: handler))
        alert.addAction(UIAlertAction(title: "Ho", style: .Default, handler: handler))
        alert.addAction(UIAlertAction(title: "Hey Nonny No", style: .Default, handler: handler))
        self.presentViewController(alert, animated: true, completion: nil)
        // if we do no more than that, we'll crash with a helpful error message:
        // "UIPopoverPresentationController should have a non-nil sourceView or barButtonItem set before the presentation occurs"
        // so the runtime knows that on iPad this should be a popover, and has arranged it already
        // all we have to do is fulfill our usual popover responsibilities
        if let pop = alert.popoverPresentationController {
            pop.barButtonItem = sender as! UIBarButtonItem
            // but now we have the usual foo where we must prevent the bar button items
            // from being "live"; why isn't this automatic???
            // still, it isn't anywhere near as bad as in previous systems
            delay(0.1) {
                pop.passthroughViews = nil
            }
        }
    }
    
    @IBAction func doOtherThing(sender:AnyObject) {
        let pvc = PopoverViewController(nibName: "PopoverViewController", bundle: nil)
        pvc.modalPresentationStyle = .Popover
        self.presentViewController(pvc, animated: true, completion: nil)
        if let pop = pvc.popoverPresentationController {
            pop.barButtonItem = sender as! UIBarButtonItem
            //pop.delegate = self
            delay(0.1) {
                pop.passthroughViews = nil
            }
        }
    }

}

// not needed in iOS 8.3

/*
extension ViewController : UIPopoverPresentationControllerDelegate {
    func popoverPresentationControllerShouldDismissPopover(
        pop: UIPopoverPresentationController) -> Bool {
            let ok = pop.presentedViewController.presentedViewController == nil
            return ok
    }
}
*/

extension ViewController : UIToolbarDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}
