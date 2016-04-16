

import UIKit

class ViewController: UIViewController {
}

class ViewController2: UIViewController {
    @IBAction func doDismiss(_ sender: AnyObject) {
        self.dismiss(animated:true, completion: nil)
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
        dest.modalPresentationStyle = .custom
        dest.transitioningDelegate = self
        super.perform()
    }
}
extension MyCoolSegue: UIViewControllerTransitioningDelegate {
    @objc(animationControllerForPresentedController:presentingController:sourceController:)
    func animationController(forPresentedController presented: UIViewController, presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    @objc(animationControllerForDismissedController:)
    func animationController(forDismissedController dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
extension MyCoolSegue: UIViewControllerAnimatedTransitioning {
    func transitionDuration(_ transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.8
    }
    func animateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let vc1 = transitionContext.viewController(forKey:UITransitionContextFromViewControllerKey)!
        let vc2 = transitionContext.viewController(forKey:UITransitionContextToViewControllerKey)!
        
        let con = transitionContext.containerView()!
        
        let r1start = transitionContext.initialFrame(for:vc1)
        let r2end = transitionContext.finalFrame(for:vc2)
        
        if let v2 = transitionContext.view(forKey:UITransitionContextToViewKey) {
            var r2start = r2end
            r2start.origin.y -= r2start.size.height
            v2.frame = r2start
            con.addSubview(v2)
            UIView.animate(withDuration:0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [], animations: {
                v2.frame = r2end
                }, completion: {
                    _ in
                    transitionContext.completeTransition(true)
            })
        } else if let v1 = transitionContext.view(forKey:UITransitionContextFromViewKey) {
            var r1end = r1start
            r1end.origin.y = -r1end.size.height
            UIView.animate(withDuration:0.8, animations: {
                v1.frame = r1end
                }, completion: {
                    _ in
                    transitionContext.completeTransition(true)
            })
        }
    }
    


}


