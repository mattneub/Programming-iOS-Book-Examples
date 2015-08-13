

import UIKit

/*
Showing how iOS 9 performs a complex unwind involving multiple parent view controllers.
In the first tab, do a push.
Switch to the second tab. Do a present.
Now unwind. We successfully unwind all the way back to the first tab!
So the second tab dismisses, the tab controller switches to the first tab, and the first tab nav controller pops.
How on earth is this possible?! There's no code at all (except for the unwind-to-here marker), but the right thing happens.

Logging reveals the sequence:

// prelude: source gets a chance to veto the whole thing
ExtraViewController shouldPerformSegueWithIdentifier(_:sender:) true

// === first we establish the path from the source to the destination
// === we also establish _who_ is the destination; note that we only ask "can perform" if you have no eligible children
// (makes perfect sense: having eligible children already means "it's not me")

// I have no children and it isn't me
SecondViewController allowedChildViewControllersForUnwindingFromSource []
SecondViewController canPerformUnwindSegueAction(_:fromViewController:withSender:) false

// I have no children and it isn't me
This one looks like a bug to me: why do we go _down_ into a child when we were told there were no eligible children?
ExtraViewController allowedChildViewControllersForUnwindingFromSource []
ExtraViewController canPerformUnwindSegueAction(_:fromViewController:withSender:) false

// I have one! it's the nav controller in the first tab
MyTabBarController allowedChildViewControllersForUnwindingFromSource [<TabbedUnwind.MyNavController: 0x7fbb5c817600>]

// I have two!
MyNavController allowedChildViewControllersForUnwindingFromSource [<TabbedUnwind.ExtraViewController: 0x7fbb5bc0b4d0>, <TabbedUnwind.FirstViewController: 0x7fbb5bd13e00>]

// I have no children and it isn't me
ExtraViewController allowedChildViewControllersForUnwindingFromSource []
ExtraViewController canPerformUnwindSegueAction(_:fromViewController:withSender:) false

I have no children and it _is_ me!
FirstViewController allowedChildViewControllersForUnwindingFromSource []
FirstViewController canPerformUnwindSegueAction(_:fromViewController:withSender:) true

// === we have now established the path; now we perform the unwind in stages
// === note that MyTabBarController is told to unwind to the nav controller; the nav controller is told to unwind to the root vc

FirstViewController iAmFirst // the marker method is called

MyTabBarController dismissViewControllerAnimated(_:completion:)

MyTabBarController unwindForSegue(_:towardsViewController:) <TabbedUnwind.MyNavController: 0x7fbb5c817600>

MyNavController unwindForSegue(_:towardsViewController:) <TabbedUnwind.FirstViewController: 0x7fbb5bd13e00>

*/

class FirstViewController: UIViewController {
    
    @IBAction func iAmFirst (sender:UIStoryboardSegue!) {
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
        print("\(self.dynamicType) \(__FUNCTION__) \(result)")
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

