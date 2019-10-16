

import UIKit

/*
 
 What we have here is a straightforward push-then-present to unwind.

 ViewController3 shouldPerformSegue(withIdentifier:sender:) true
 
 ViewController2 allowedChildViewControllersForUnwinding(from:) []
 view controller 2 is asked if it responds to unwind:
 ViewController2 canPerformUnwindSegueAction(_:from:withSender:) unwind: false
 
 At this point there is what I regard as a bug, and I have reported it as such.
 We dive back down to ViewController3, and I can't imagine why.
 After all, ViewController2 has already told us it has no relevant children.
 So why are we pursuing this branch at all?
 
 ViewController3 allowedChildViewControllersForUnwinding(from:) []
 ViewController3 canPerformUnwindSegueAction(_:from:withSender:) unwind: false
 
 Now things go back to normal:
 
 MyNavigationController allowedChildViewControllersForUnwinding(from:) [<ch19p645unwindSimplified.ViewController: 0x7fe5445061d0>]
 ViewController allowedChildViewControllersForUnwinding(from:) []
 ViewController is asked if it responds to unwind:
 ViewController canPerformUnwindSegueAction(_:from:withSender:) unwind: true
 
 And now we unwind in good order:
 
 ViewController3 prepare(for:sender:)
 view controller 1 unwind is called
 MyNavigationController dismiss(animated:completion:)
 MyNavigationController unwind(for:towardsViewController:) <ch19p645unwindSimplified.ViewController: 0x7fe5445061d0>
 MyNavigationController popToViewController(_:animated:)

 
 */

class ViewController : UIViewController {
    
    @IBAction func unwind(_ seg:UIStoryboardSegue) {
        print("view controller 1 unwind is called")
    }

    override func responds(to aSelector: Selector) -> Bool {
        if NSStringFromSelector(aSelector) == "unwind:" {
            print("\(type(of:self)) is asked if it responds to \(aSelector)")
        }
        let result = super.responds(to: aSelector)
        return result
    }
    
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
    


}
