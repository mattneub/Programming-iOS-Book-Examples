
import UIKit

class ViewController: UIViewController {
    
    /*
    Run under iOS 7 and iOS 8.
    The difference is that in iOS 8 the child is skipped
    and the runtime goes straight to the parent;
    the parent thus must choose a child to unwind to
    (the default is self, which might or might not make sense)
*/

    @IBAction func unwind(segue:UIStoryboardSegue!) {
        println("view controller unwind")
    }

    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        var result = true
        
        println("view controller can perform returns \(result)")
        return result
    }
    
    override func viewControllerForUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject!) -> UIViewController? {
        
        println("view controller vc for unwind called...")
        var result : UIViewController? = nil
        
        let vc = super.viewControllerForUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
        println("view controller returns \(vc) from vc for unwind segue")
        result = vc
        return result
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        // from later in the chapter: comment out to prevent forwarding
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        println("\(self) \(__FUNCTION__)")
    }
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        // from later in the chapter: comment out to prevent forwarding
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        println("\(self) \(__FUNCTION__)")
    }



}

