
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
    
    // --> viewControllerForUnwindSegueAction deprecated
    // --> segueForUnwindingToViewController deprecated
    // replacements are:
    // allowedChildViewControllersForUnwindingFromSource
    // unwindForSegue
    
    // The idea is that allowedChildViewControllers first should call childViewControllerContainingSegueSource and then...
    // return a list of its own children _except_ for that one (we can't segue to it, it contains the source)
    // The notion of the source relies on a new value class, UIStoryboardUnwindSegueSource
    // lets you get sender, sourceViewController, unwindAction
    
    // This particular example is kind of pointless now,
    // because `dismiss` is sent by the runtime and that's all it takes to do this particular unwind


    override func allowedChildViewControllersForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwinding(from: source)
        print("\(type(of:self)) \(#function) \(result)")
        return result
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(type(of:self)) \(#function) \(subsequentVC)")
        super.unwind(for: unwindSegue, towardsViewController: subsequentVC)
    }
    
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, from: fromViewController, withSender: sender)
        print("\(type(of:self)) \(#function) \(action) \(result)")
        return result
    }
    
    override func dismiss(animated: Bool, completion: (() -> Void)?) {
        print("\(type(of:self)) \(#function)")
        super.dismiss(animated:animated, completion: completion)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let result = super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        if identifier == "unwind" {
            print("\(type(of:self)) \(#function) \(result)")
        }
        return result
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwind" {
            print("\(type(of:self)) \(#function)")
        }
    }
    

        
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // from later in the chapter: comment out to prevent forwarding
        super.viewWillTransition(to: size, with: coordinator)
        print("\(self) \(#function)")
    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        // from later in the chapter: comment out to prevent forwarding
        super.willTransition(to: newCollection, with: coordinator)
        print("\(self) \(#function)")
    }



}

