
import UIKit

class ViewController: UIViewController {
    
    // the whole unwind architecture has been revamped (again) in iOS 9
    // in this example, we now never get to the parent (view controller)
    // we reach the contained vc (view controller 2) and all the work happens there
    // thus the parent is not forced to answer the difficult question of who should do the segue
    // but the parent still _does_ the segue! `unwindForSegue` is called, and now what happens is up to this parent
    // but (although this example does not show it) the parent is _not alone_:
    // _all_ parents along the way get a crack at this; thus each one gets an incremental `unwindForSegue` to mediate among his children
    // (the second parameter, "subsequentVC", is one of its children, not necessarily the final destination)
    

    @IBAction func unwind(segue:UIStoryboardSegue!) {
        print("view controller unwind")
    }
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
        
        print("view controller can perform returns \(result)")
        return result
    }
    
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("view controller told to unwind for segue")
        super.unwindForSegue(unwindSegue, towardsViewController:subsequentVC)
    }
    
    // --> viewControllerForUnwindSegueAction deprecated
    // --> segueForUnwindingToViewController deprecated
    // replacements are:
    // allowedChildViewControllersForUnwindingFromSource
    // unwindForSegue
    
    // The idea is that allowedChildViewControllers first should call childViewControllerContainingSegueSource and then...
    // return a list of its own children _except_ for that one (we can't segue to it, it contains the source)
    // The notion of the source relies on a new value class, UIStoryboardUnwindSegueSource
    // lets you get sender, sourceViewController, unwindAction

    
    override func allowedChildViewControllersForUnwindingFromSource(source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        print("view controller allowed child vcs called...")
        let vcs = super.allowedChildViewControllersForUnwindingFromSource(source)
        print("view controller the source was \(source.sourceViewController) sent by \(source.sender)")
        print("view controller returns \(vcs) from allowed child vcs")
        return vcs
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        // from later in the chapter: comment out to prevent forwarding
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        print("\(self) \(__FUNCTION__)")
    }
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        // from later in the chapter: comment out to prevent forwarding
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        print("\(self) \(__FUNCTION__)")
    }



}

