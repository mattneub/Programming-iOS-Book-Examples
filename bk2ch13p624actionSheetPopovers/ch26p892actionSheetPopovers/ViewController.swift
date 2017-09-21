
import UIKit
func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

class ViewController: UIViewController {
    

    @IBOutlet var toolbar : UIToolbar!
    
    @IBAction func doButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        func handler(_ act:UIAlertAction!) {
            print("User tapped \(act.title as Any)")
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: handler)) // not shown
        alert.addAction(UIAlertAction(title: "Hey", style: .default, handler: handler))
        alert.addAction(UIAlertAction(title: "Ho", style: .default, handler: handler))
        alert.addAction(UIAlertAction(title: "Hey Nonny No", style: .default, handler: handler))
        self.present(alert, animated: true) {
            alert.popoverPresentationController?.passthroughViews = nil
        }
        // if we do no more than that, we'll crash with a helpful error message:
        // "UIPopoverPresentationController should have a non-nil sourceView or barButtonItem set before the presentation occurs"
        // so the runtime knows that on iPad this should be a popover, and has arranged it already
        // all we have to do is fulfill our usual popover responsibilities
        // return;
        if let pop = alert.popoverPresentationController {
            let b = sender as! UIBarButtonItem
            pop.barButtonItem = b
        }
    }
    
    @IBAction func doOtherThing(_ sender: Any) {
        let pvc = PopoverViewController(nibName: "PopoverViewController", bundle: nil)
        pvc.modalPresentationStyle = .popover
        self.present(pvc, animated: true) {
            pvc.popoverPresentationController?.passthroughViews = nil
        }
        if let pop = pvc.popoverPresentationController {
            let b = sender as! UIBarButtonItem
            pop.barButtonItem = b
            pop.delegate = self
        }
    }

}

// not needed in iOS 8.3
// but needed again in iOS 9

extension ViewController : UIPopoverPresentationControllerDelegate {
    func popoverPresentationControllerShouldDismissPopover(
        _ pop: UIPopoverPresentationController) -> Bool {
			return pop.presentedViewController.presentedViewController == nil
    }
}

extension ViewController : UIToolbarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
