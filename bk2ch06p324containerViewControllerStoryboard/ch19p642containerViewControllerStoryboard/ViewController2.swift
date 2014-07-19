import UIKit

class ViewController2 : UIViewController {
    @IBAction func doButton(sender:AnyObject?) {
        self.presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}

// ===== the rest of the example actually demonstrates something else entirely,
// namely a current-context presentation (with custom animation)

extension ViewController2 {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.transitioningDelegate = self
        self.modalPresentationStyle = .CurrentContext
    }
}

extension ViewController2 : UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        return self
    }
}

extension ViewController2 : UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval {
        return 0.8
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning!) {
        let vc1 = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let vc2 = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let con = transitionContext.containerView()
        
        let r1start = transitionContext.initialFrameForViewController(vc1)
        let r2end = transitionContext.finalFrameForViewController(vc2)
        
        let v1 = transitionContext.viewForKey(UITransitionContextFromViewKey)
        let v2 = transitionContext.viewForKey(UITransitionContextToViewKey)
        
        // iOS 7 version
//        let v1 = vc1.view
//        let v2 = vc2.view
        
        // workaround for iOS 8 bug:
        con.clipsToBounds = true // !!! This line was not necessary in iOS 7
            
        
        var r2start = r2end
        r2start.origin.y -= r2start.size.height
        v2.frame = r2start
        con.addSubview(v2)
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 20, options: nil, animations: {
            v2.frame = r2end
            }, completion: {
                _ in
                transitionContext.completeTransition(true)
            })

    }
}