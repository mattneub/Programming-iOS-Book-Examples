
import UIKit
func delay(_ delay:Double, closure:()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.after(when: when, execute: closure)
}

class ViewController: UIViewController {
    

    @IBOutlet var toolbar : UIToolbar!
    
    @IBAction func doButton(_ sender:AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        func handler(_ act:UIAlertAction!) {
            print("User tapped \(act.title)")
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: handler)) // not shown
        alert.addAction(UIAlertAction(title: "Hey", style: .default, handler: handler))
        alert.addAction(UIAlertAction(title: "Ho", style: .default, handler: handler))
        alert.addAction(UIAlertAction(title: "Hey Nonny No", style: .default, handler: handler))
        self.present(alert, animated: true)
        // if we do no more than that, we'll crash with a helpful error message:
        // "UIPopoverPresentationController should have a non-nil sourceView or barButtonItem set before the presentation occurs"
        // so the runtime knows that on iPad this should be a popover, and has arranged it already
        // all we have to do is fulfill our usual popover responsibilities
        // return;
        if let pop = alert.popoverPresentationController {
            let b = sender as! UIBarButtonItem
            pop.barButtonItem = b
            // but now we have the usual foo where we must prevent the bar button items
            // from being "live"; why isn't this automatic???
            // still, it isn't anywhere near as bad as in previous systems
            delay(0.1) {
                pop.passthroughViews = nil
            }
        }
    }
    
    @IBAction func doOtherThing(_ sender:AnyObject) {
        let pvc = PopoverViewController(nibName: "PopoverViewController", bundle: nil)
        pvc.modalPresentationStyle = .popover
        self.present(pvc, animated: true)
        if let pop = pvc.popoverPresentationController {
            let b = sender as! UIBarButtonItem
            pop.barButtonItem = b
            pop.delegate = self
            delay(0.1) {
                pop.passthroughViews = nil
            }
        }
    }

}

// not needed in iOS 8.3
// but needed again in iOS 9

extension ViewController : UIPopoverPresentationControllerDelegate {
    func popoverPresentationControllerShouldDismissPopover(
        _ pop: UIPopoverPresentationController) -> Bool {
            let ok = pop.presentedViewController.presentedViewController == nil
            return ok
    }
}

extension ViewController : UIToolbarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
