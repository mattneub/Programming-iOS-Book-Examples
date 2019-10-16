
import UIKit

class ViewController: UIViewController {
    
    // --> viewControllerForUnwindSegueAction deprecated
    // --> segueForUnwindingToViewController deprecated
    // replacements are:
    // allowedChildViewControllersForUnwindingFromSource
    // unwindForSegue
    
    // However, this particular example is kind of pointless now,
    // because `dismiss` is sent by the runtime and that's all it takes to do this particular unwind
    // So in a way all it proves is that dismissal works fine to a child v.c.
    
    /*
     ViewController3 shouldPerformSegue(withIdentifier:sender:) true
     ViewController3 allowedChildViewControllersForUnwinding(from:) []
     ViewController3 canPerformUnwindSegueAction(_:from:withSender:) unwind: false
     ViewController2 allowedChildViewControllersForUnwinding(from:) []
     ViewController2 canPerformUnwindSegueAction(_:from:withSender:) unwind: true
     ViewController3 prepare(for:sender:)
     vc 2 unwind
     ViewController2 dismiss(animated:completion:)
 */


    override func allowedChildrenForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildrenForUnwinding(from: source)
        print("\(type(of:self)) \(#function) \(result)")
        return result
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        print("\(type(of:self)) \(#function) \(subsequentVC)")
        super.unwind(for: unwindSegue, towards: subsequentVC)
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

