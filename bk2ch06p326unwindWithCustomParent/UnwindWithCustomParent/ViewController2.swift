
import UIKit

class ViewController2: UIViewController {

    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        var result = true
        
        println("view controller 2 can perform returns \(result)")
        return result
    }

    override func viewControllerForUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject!) -> UIViewController? {
        
        println("view controller2 vc for unwind called...")
        var result : UIViewController? = nil
        
        let vc = super.viewControllerForUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
        println("view controller 2 returns \(vc) from vc for unwind segue")
        result = vc
        return result
    }
    
    @IBAction func unwind(segue:UIStoryboardSegue!) {
        println("vc 2 unwind")
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        println("\(self) \(__FUNCTION__)")
    }
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        println("\(self) \(__FUNCTION__)")
    }



}
