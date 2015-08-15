

import UIKit


class ViewController1: UIViewController {

    @IBAction func unwind (sender:UIStoryboardSegue) {
        print("\(self.dynamicType) \(__FUNCTION__)")
    }
    
    override func allowedChildViewControllersForUnwindingFromSource(source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwindingFromSource(source)
        print("\(self.dynamicType) \(__FUNCTION__) \(result)")
        return result
    }
    
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(self.dynamicType) \(__FUNCTION__) \(subsequentVC)")
        super.unwindForSegue(unwindSegue, towardsViewController: subsequentVC)
    }
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
        print("\(self.dynamicType) \(__FUNCTION__) \(action) \(fromViewController.dynamicType) \(sender.dynamicType) \(result)")
        return result
    }
    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        print("\(self.dynamicType) \(__FUNCTION__)")
        super.dismissViewControllerAnimated(flag, completion: completion)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        let result = super.shouldPerformSegueWithIdentifier(identifier, sender: sender)
        if identifier == "unwind" {
            print("\(self.dynamicType) \(__FUNCTION__) \(result)")
        }
        return result
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwind" {
            print("\(self.dynamicType) \(__FUNCTION__)")
        }
    }


}

class ViewController2: UIViewController {
    
    override func allowedChildViewControllersForUnwindingFromSource(source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwindingFromSource(source)
        print("\(self.dynamicType) \(__FUNCTION__) \(result)")
        return result
    }
    
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(self.dynamicType) \(__FUNCTION__) \(subsequentVC)")
        super.unwindForSegue(unwindSegue, towardsViewController: subsequentVC)
    }
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
        print("\(self.dynamicType) \(__FUNCTION__) \(action) \(fromViewController.dynamicType) \(sender.dynamicType) \(result)")
        return result
    }
    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        print("\(self.dynamicType) \(__FUNCTION__)")
        super.dismissViewControllerAnimated(flag, completion: completion)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        let result = super.shouldPerformSegueWithIdentifier(identifier, sender: sender)
        if identifier == "unwind" {
            print("\(self.dynamicType) \(__FUNCTION__) \(result)")
        }
        return result
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwind" {
            print("\(self.dynamicType) \(__FUNCTION__)")
        }
    }


}

class ViewController3: UIViewController {
    
    override func allowedChildViewControllersForUnwindingFromSource(source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwindingFromSource(source)
        print("\(self.dynamicType) \(__FUNCTION__) \(result)")
        return result
    }
    
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(self.dynamicType) \(__FUNCTION__) \(subsequentVC)")
        super.unwindForSegue(unwindSegue, towardsViewController: subsequentVC)
    }
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
        print("\(self.dynamicType) \(__FUNCTION__) \(action) \(fromViewController.dynamicType) \(sender.dynamicType) \(result)")
        return result
    }
    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        print("\(self.dynamicType) \(__FUNCTION__)")
        super.dismissViewControllerAnimated(flag, completion: completion)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        let result = super.shouldPerformSegueWithIdentifier(identifier, sender: sender)
        if identifier == "unwind" {
            print("\(self.dynamicType) \(__FUNCTION__) \(result)")
        }
        return result
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwind" {
            print("\(self.dynamicType) \(__FUNCTION__)")
        }
    }


}

class ViewController4: UIViewController {
    
    override func allowedChildViewControllersForUnwindingFromSource(source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwindingFromSource(source)
        print("\(self.dynamicType) \(__FUNCTION__) \(result)")
        return result
    }
    
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(self.dynamicType) \(__FUNCTION__) \(subsequentVC)")
        super.unwindForSegue(unwindSegue, towardsViewController: subsequentVC)
    }
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
        print("\(self.dynamicType) \(__FUNCTION__) \(action) \(fromViewController.dynamicType) \(sender.dynamicType) \(result)")
        return result
    }
    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        print("\(self.dynamicType) \(__FUNCTION__)")
        super.dismissViewControllerAnimated(flag, completion: completion)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        let result = super.shouldPerformSegueWithIdentifier(identifier, sender: sender)
        if identifier == "unwind" {
            print("\(self.dynamicType) \(__FUNCTION__) \(result)")
        }
        return result
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwind" {
            print("\(self.dynamicType) \(__FUNCTION__)")
        }
    }
    
    
}

class MyTabBarController: UITabBarController {
    
    override func allowedChildViewControllersForUnwindingFromSource(source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwindingFromSource(source)
        print("\(self.dynamicType) \(__FUNCTION__) \(result)")
        return result
    }
    
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(self.dynamicType) \(__FUNCTION__) \(subsequentVC)")
        super.unwindForSegue(unwindSegue, towardsViewController: subsequentVC)
    }
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
        print("\(self.dynamicType) \(__FUNCTION__) \(action) \(fromViewController.dynamicType) \(sender.dynamicType) \(result)")
        return result
    }
    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        print("\(self.dynamicType) \(__FUNCTION__)")
        super.dismissViewControllerAnimated(flag, completion: completion)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        let result = super.shouldPerformSegueWithIdentifier(identifier, sender: sender)
        if identifier == "unwind" {
            print("\(self.dynamicType) \(__FUNCTION__) \(result)")
        }
        return result
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwind" {
            print("\(self.dynamicType) \(__FUNCTION__)")
        }
    }
    
    
}

class TabChild1: UIViewController {
    
    override func allowedChildViewControllersForUnwindingFromSource(source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwindingFromSource(source)
        print("\(self.dynamicType) \(__FUNCTION__) \(result)")
        return result
    }
    
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(self.dynamicType) \(__FUNCTION__) \(subsequentVC)")
        super.unwindForSegue(unwindSegue, towardsViewController: subsequentVC)
    }
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
        print("\(self.dynamicType) \(__FUNCTION__) \(action) \(fromViewController.dynamicType) \(sender.dynamicType) \(result)")
        return result
    }
    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        print("\(self.dynamicType) \(__FUNCTION__)")
        super.dismissViewControllerAnimated(flag, completion: completion)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        let result = super.shouldPerformSegueWithIdentifier(identifier, sender: sender)
        if identifier == "unwind" {
            print("\(self.dynamicType) \(__FUNCTION__) \(result)")
        }
        return result
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwind" {
            print("\(self.dynamicType) \(__FUNCTION__)")
        }
    }
    
    
}
class TabChild2: UIViewController {
    
    override func allowedChildViewControllersForUnwindingFromSource(source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildViewControllersForUnwindingFromSource(source)
        print("\(self.dynamicType) \(__FUNCTION__) \(result)")
        return result
    }
    
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("\(self.dynamicType) \(__FUNCTION__) \(subsequentVC)")
        super.unwindForSegue(unwindSegue, towardsViewController: subsequentVC)
    }
    
    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
        print("\(self.dynamicType) \(__FUNCTION__) \(action) \(fromViewController.dynamicType) \(sender.dynamicType) \(result)")
        return result
    }
    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        print("\(self.dynamicType) \(__FUNCTION__)")
        super.dismissViewControllerAnimated(flag, completion: completion)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        let result = super.shouldPerformSegueWithIdentifier(identifier, sender: sender)
        if identifier == "unwind" {
            print("\(self.dynamicType) \(__FUNCTION__) \(result)")
        }
        return result
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwind" {
            print("\(self.dynamicType) \(__FUNCTION__)")
        }
    }
    
    
}




