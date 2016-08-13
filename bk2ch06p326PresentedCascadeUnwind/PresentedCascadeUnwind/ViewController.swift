

import UIKit

/*

Showing the recursive repetition of the walk from the bottom up, three times (once for each parent of a presented v.c., I suppose)
I can't understand the purpose this, and I assume it's a bug, but I could be wrong

ViewController4 shouldPerformSegueWithIdentifier(_:sender:) true

ViewController4 allowedChildViewControllersForUnwindingFromSource []
ViewController4 canPerformUnwindSegueAction(_:fromViewController:withSender:) unwind: false
ViewController3 allowedChildViewControllersForUnwindingFromSource []
ViewController3 canPerformUnwindSegueAction(_:fromViewController:withSender:) unwind: false
ViewController4 allowedChildViewControllersForUnwindingFromSource []
ViewController4 canPerformUnwindSegueAction(_:fromViewController:withSender:) unwind: false
ViewController3 allowedChildViewControllersForUnwindingFromSource []
ViewController3 canPerformUnwindSegueAction(_:fromViewController:withSender:) unwind: false
ViewController2 allowedChildViewControllersForUnwindingFromSource []
ViewController2 canPerformUnwindSegueAction(_:fromViewController:withSender:) unwind: false
ViewController4 allowedChildViewControllersForUnwindingFromSource []
ViewController4 canPerformUnwindSegueAction(_:fromViewController:withSender:) unwind: false
ViewController3 allowedChildViewControllersForUnwindingFromSource []
ViewController3 canPerformUnwindSegueAction(_:fromViewController:withSender:) unwind: false
ViewController2 allowedChildViewControllersForUnwindingFromSource []
ViewController2 canPerformUnwindSegueAction(_:fromViewController:withSender:) unwind: false
ViewController1 allowedChildViewControllersForUnwindingFromSource []
ViewController1 canPerformUnwindSegueAction(_:fromViewController:withSender:) unwind: true

ViewController4 prepareForSegue(_:sender:)
ViewController1 unwind
ViewController1 dismiss(animated:_:completion:)


*/

/*
 Okay, I guess it was a bug, because they fixed it! In iOS 10, you get exactly what you would expect:
 
 ViewController4 shouldPerformSegue(withIdentifier:sender:) true
 ViewController4 allowedChildViewControllersForUnwinding(from:) []
 ViewController4 canPerformUnwindSegueAction(_:from:withSender:) unwind: false
 ViewController3 allowedChildViewControllersForUnwinding(from:) []
 ViewController3 canPerformUnwindSegueAction(_:from:withSender:) unwind: false
 ViewController2 allowedChildViewControllersForUnwinding(from:) []
 ViewController2 canPerformUnwindSegueAction(_:from:withSender:) unwind: false
 ViewController1 allowedChildViewControllersForUnwinding(from:) []
 ViewController1 canPerformUnwindSegueAction(_:from:withSender:) unwind: true
 
 ViewController4 prepare(for:sender:)
 ViewController1 unwind
 ViewController1 dismiss(animated:completion:)

 */


class ViewController1: UIViewController {

    @IBAction func unwind (_ sender:UIStoryboardSegue) {
        print("\(self.dynamicType) \(#function)")
    }
    
    override func allowedChildViewControllersForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwinding(from: source)
        print("\(self.dynamicType) \(#function) \(result)")
        return result
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(self.dynamicType) \(#function) \(subsequentVC)")
        super.unwind(for: unwindSegue, towardsViewController: subsequentVC)
    }
    
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, from: fromViewController, withSender: sender)
        print("\(self.dynamicType) \(#function) \(action) \(result)")
        return result
    }
    
    override func dismiss(animated:Bool, completion: (() -> Void)?) {
        print("\(self.dynamicType) \(#function)")
        super.dismiss(animated:animated, completion: completion)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: AnyObject?) -> Bool {
        let result = super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        if identifier == "unwind" {
            print("\(self.dynamicType) \(#function) \(result)")
        }
        return result
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwind" {
            print("\(self.dynamicType) \(#function)")
        }
    }


}

class ViewController2: UIViewController {
    
    override func allowedChildViewControllersForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwinding(from: source)
        print("\(self.dynamicType) \(#function) \(result)")
        return result
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(self.dynamicType) \(#function) \(subsequentVC)")
        super.unwind(for: unwindSegue, towardsViewController: subsequentVC)
    }
    
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, from: fromViewController, withSender: sender)
        print("\(self.dynamicType) \(#function) \(action) \(result)")
        return result
    }
    
    override func dismiss(animated: Bool, completion: (() -> Void)?) {
        print("\(self.dynamicType) \(#function)")
        super.dismiss(animated:animated, completion: completion)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: AnyObject?) -> Bool {
        let result = super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        if identifier == "unwind" {
            print("\(self.dynamicType) \(#function) \(result)")
        }
        return result
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwind" {
            print("\(self.dynamicType) \(#function)")
        }
    }


}

class ViewController3: UIViewController {
    
    override func allowedChildViewControllersForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwinding(from: source)
        print("\(self.dynamicType) \(#function) \(result)")
        return result
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(self.dynamicType) \(#function) \(subsequentVC)")
        super.unwind(for: unwindSegue, towardsViewController: subsequentVC)
    }
    
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, from: fromViewController, withSender: sender)
        print("\(self.dynamicType) \(#function) \(action) \(result)")
        return result
    }
    
    override func dismiss(animated: Bool, completion: (() -> Void)?) {
        print("\(self.dynamicType) \(#function)")
        super.dismiss(animated:animated, completion: completion)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: AnyObject?) -> Bool {
        let result = super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        if identifier == "unwind" {
            print("\(self.dynamicType) \(#function) \(result)")
        }
        return result
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwind" {
            print("\(self.dynamicType) \(#function)")
        }
    }


}

class ViewController4: UIViewController {
    
    override func allowedChildViewControllersForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwinding(from: source)
        print("\(self.dynamicType) \(#function) \(result)")
        return result
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(self.dynamicType) \(#function) \(subsequentVC)")
        super.unwind(for: unwindSegue, towardsViewController: subsequentVC)
    }
    
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, from: fromViewController, withSender: sender)
        print("\(self.dynamicType) \(#function) \(action) \(result)")
        return result
    }
    
    override func dismiss(animated: Bool, completion: (() -> Void)?) {
        print("\(self.dynamicType) \(#function)")
        super.dismiss(animated:animated, completion: completion)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: AnyObject?) -> Bool {
        let result = super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        if identifier == "unwind" {
            print("\(self.dynamicType) \(#function) \(result)")
        }
        return result
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwind" {
            print("\(self.dynamicType) \(#function)")
        }
    }
    
    
}



