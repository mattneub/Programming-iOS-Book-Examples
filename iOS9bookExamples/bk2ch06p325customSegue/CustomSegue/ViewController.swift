

import UIKit

class ViewController: UIViewController {
}

class ViewController2: UIViewController {
    @IBAction func doDismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

// in iOS 9...
// the segue itself is able to act as animated transitioning object to customize pres. animation
// this is possible because it is retained and still exists at dismissal time
// it can also call super.perform, and in connection with this...
// Xcode 7 lets you specify a custom segue class without saying Custom for the segue:
// we are customizing a standard present modally segue

class MyCoolSegue: UIStoryboardSegue {
    override func perform() {
        let dest = self.destinationViewController
        dest.modalPresentationStyle = .Custom
        dest.transitioningDelegate = self
        super.perform()
    }
}
extension MyCoolSegue: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
extension MyCoolSegue: UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.8
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let vc1 = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let vc2 = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let con = transitionContext.containerView()!
        
        let r1start = transitionContext.initialFrameForViewController(vc1)
        let r2end = transitionContext.finalFrameForViewController(vc2)
        
        if let v2 = transitionContext.viewForKey(UITransitionContextToViewKey) {
            var r2start = r2end
            r2start.origin.y -= r2start.size.height
            v2.frame = r2start
            con.addSubview(v2)
            UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [], animations: {
                v2.frame = r2end
                }, completion: {
                    _ in
                    transitionContext.completeTransition(true)
            })
        } else if let v1 = transitionContext.viewForKey(UITransitionContextFromViewKey) {
            var r1end = r1start
            r1end.origin.y = -r1end.size.height
            UIView.animateWithDuration(0.8, animations: {
                v1.frame = r1end
                }, completion: {
                    _ in
                    transitionContext.completeTransition(true)
            })
        }
    }
    


}


