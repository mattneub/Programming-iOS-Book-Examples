
import UIKit

class ViewController2: UIViewController {

    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
        
        print("view controller 2 can perform returns \(result)")
        return result
    }

    override func allowedChildViewControllersForUnwindingFromSource(source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        print("view controller 2 allowed child vcs called...")
        let vcs = super.allowedChildViewControllersForUnwindingFromSource(source)
        print("view controller 2 the source was \(source.sourceViewController) sent by \(source.sender)")
        print("view controller 2 returns \(vcs) from allowed child vcs")
        return vcs
    }
    
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("view controller 2 told to unwind for segue")
        super.unwindForSegue(unwindSegue, towardsViewController:subsequentVC)
    }

    
    @IBAction func unwind(segue:UIStoryboardSegue!) {
        print("vc 2 unwind")
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        print("\(self) \(__FUNCTION__)")
    }
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        print("\(self) \(__FUNCTION__)")
    }



}
