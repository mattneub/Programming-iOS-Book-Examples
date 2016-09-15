
import UIKit


class ViewController : UIViewController {
    @IBAction func doButton(sender:AnyObject?) {
        // for comparison purposes
//        let alert = UIAlertController(title: "Howdy", message: "This is a test", preferredStyle: .Alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
//        self.presentViewController(alert, animated:true, completion:nil)
//        return;
        self.presentViewController(ViewController2(), animated:true, completion:nil)
    }
}

// imitate an alert view

class ViewController2 : UIViewController {
    @IBOutlet var button : UIButton!
    
    @IBAction func doButton(sender:AnyObject?) {
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.borderColor = self.view.tintColor.CGColor
        self.view.layer.borderWidth = 2
        self.view.layer.cornerRadius = 10
        self.view.layer.masksToBounds = true
        self.button.layer.borderColor = self.button.tintColor!.CGColor
        self.button.layer.borderWidth = 1
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(10,10), false, 0)
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext()!, UIColor(white:0.4, alpha:1.5).CGColor)
        CGContextFillRect(UIGraphicsGetCurrentContext()!, CGRectMake(0,0,10,10))
        let im = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.button.setBackgroundImage(im, forState:.Highlighted)
    }
    
    init() {
        super.init(nibName: "ViewController2", bundle: nil)
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = self
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

}

extension ViewController2 : UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return MyPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
}

class MyPresentationController : UIPresentationController {
    override func presentationTransitionWillBegin() {
        let con = self.containerView!
        let shadow = UIView(frame:con.bounds)
        shadow.backgroundColor = UIColor(white:0, alpha:0.4)
        shadow.alpha = 0
        con.insertSubview(shadow, atIndex: 0)
        shadow.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        let tc = self.presentedViewController.transitionCoordinator()!
        tc.animateAlongsideTransition({
            _ in
            shadow.alpha = 1
            }, completion: {
                _ in
                let vc = self.presentingViewController
                let v = vc.view
                v.tintAdjustmentMode = .Dimmed
            })
    }
    
    override func dismissalTransitionWillBegin() {
        let con = self.containerView!
        let shadow = con.subviews[0]
        let tc = self.presentedViewController.transitionCoordinator()!
        tc.animateAlongsideTransition({
            _ in
            shadow.alpha = 0
            }, completion: {
                _ in
                let vc = self.presentingViewController
                let v = vc.view
                v.tintAdjustmentMode = .Automatic
            })
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        // we want to center the presented view at its "native" size
        // I can think of a lot of ways to do this,
        // but here we just assume that it *is* its native size
        let v = self.presentedView()!
        let con = self.containerView!
        v.center = CGPointMake(con.bounds.midX, con.bounds.midY)
        return v.frame.integral
    }
    
    override func containerViewWillLayoutSubviews() {
        // deal with future rotation
        // again, I can think of more than one approach
        let v = self.presentedView()!
        v.autoresizingMask = [.FlexibleTopMargin, .FlexibleBottomMargin,
            .FlexibleLeftMargin, .FlexibleRightMargin]
    }
    
}

extension ViewController2 /* UIViewControllerTransitioningDelegate */ {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension ViewController2 : UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?)
        -> NSTimeInterval {
            return 0.25
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // let vc1 = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        // let vc2 = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let con = transitionContext.containerView()!
        
        // let r1start = transitionContext.initialFrameForViewController(vc1!)
        // let r2end = transitionContext.finalFrameForViewController(vc2!)
        
        let v1 = transitionContext.viewForKey(UITransitionContextFromViewKey)
        let v2 = transitionContext.viewForKey(UITransitionContextToViewKey)
        
        // we are using the same object (self) as animation controller
        // for both presentation and dismissal
        // so we have to distinguish the two cases
        
        if let v2 = v2 {
            con.addSubview(v2)
            let scale = CGAffineTransformMakeScale(1.6,1.6)
            v2.transform = scale
            v2.alpha = 0
            UIView.animateWithDuration(0.25, animations: {
                v2.alpha = 1
                v2.transform = CGAffineTransformIdentity
                }, completion: {
                    _ in
                    transitionContext.completeTransition(true)
                })
        } else if let v1 = v1 {
            UIView.animateWithDuration(0.25, animations: {
                v1.alpha = 0
                }, completion: {
                    _ in
                    transitionContext.completeTransition(true)
                })
        }
        
    }

}
