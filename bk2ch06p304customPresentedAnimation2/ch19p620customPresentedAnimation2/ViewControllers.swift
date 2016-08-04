
import UIKit

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}




class ViewController : UIViewController {
    @IBAction func doButton(_ sender:AnyObject?) {
        // for comparison purposes
//        let alert = UIAlertController(title: "Howdy", message: "This is a test", preferredStyle: .Alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .Cancel))
//        self.present(alert, animated:true)
//        return;
        self.present(ViewController2(), animated:true)
    }
}

// imitate an alert view

class ViewController2 : UIViewController {
    @IBOutlet var button : UIButton!
    
    @IBAction func doButton(_ sender:AnyObject?) {
        self.presentingViewController!.dismiss(animated:true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.borderColor = self.view.tintColor.cgColor
        self.view.layer.borderWidth = 2
        self.view.layer.cornerRadius = 10
        self.view.layer.masksToBounds = true
        self.button.layer.borderColor = self.button.tintColor!.cgColor
        self.button.layer.borderWidth = 1
        let r = UIGraphicsImageRenderer(size:CGSize(10,10))
        let im = r.image {
            ctx in let con = ctx.cgContext
            con.setFillColor(UIColor(white:0.4, alpha:1.5).cgColor)
            con.fill(CGRect(0,0,10,10))
        }

//        UIGraphicsBeginImageContextWithOptions(CGSize(10,10), false, 0)
//        let con = UIGraphicsGetCurrentContext()!
//        con.setFillColor(UIColor(white:0.4, alpha:1.5).cgColor)
//        con.fill(CGRect(0,0,10,10))
//        let im = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
        
        self.button.setBackgroundImage(im, for:.highlighted)
    }
    
    init() {
        super.init(nibName: "ViewController2", bundle: nil)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

}

extension ViewController2 : UIViewControllerTransitioningDelegate {
    func presentationController(forPresentedViewController presented: UIViewController, presenting: UIViewController?, sourceViewController source: UIViewController) -> UIPresentationController? {
        return MyPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class MyPresentationController : UIPresentationController {
    override func presentationTransitionWillBegin() {
        let con = self.containerView!
        let shadow = UIView(frame:con.bounds)
        shadow.backgroundColor = UIColor(white:0, alpha:0.4)
        shadow.alpha = 0
        con.insertSubview(shadow, at: 0)
        shadow.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let tc = self.presentedViewController.transitionCoordinator!
        tc.animate(alongsideTransition:{
            _ in
            shadow.alpha = 1
            }, completion: {
                _ in
                let vc = self.presentingViewController
                let v = vc.view
                v?.tintAdjustmentMode = .dimmed
            })
    }
    
    override func dismissalTransitionWillBegin() {
        let con = self.containerView!
        let shadow = con.subviews[0]
        let tc = self.presentedViewController.transitionCoordinator!
        tc.animate(alongsideTransition:{
            _ in
            shadow.alpha = 0
            }, completion: {
                _ in
                let vc = self.presentingViewController
                let v = vc.view
                v?.tintAdjustmentMode = .automatic
            })
    }
    
    override var frameOfPresentedViewInContainerView : CGRect {
        // we want to center the presented view at its "native" size
        // I can think of a lot of ways to do this,
        // but here we just assume that it *is* its native size
        let v = self.presentedView!
        let con = self.containerView!
        v.center = CGPoint(con.bounds.midX, con.bounds.midY)
        return v.frame.integral
    }
    
    override func containerViewWillLayoutSubviews() {
        // deal with future rotation
        // again, I can think of more than one approach
        let v = self.presentedView!
        v.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin,
            .flexibleLeftMargin, .flexibleRightMargin]
    }
    
}

extension ViewController2 /* UIViewControllerTransitioningDelegate */ {
    @objc(animationControllerForPresentedController:presentingController:sourceController:)
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    @objc(animationControllerForDismissedController:)
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension ViewController2 : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?)
        -> TimeInterval {
            return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // let vc1 = transitionContext.viewController(forKey:UITransitionContextFromViewControllerKey)
        // let vc2 = transitionContext.viewController(forKey:UITransitionContextToViewControllerKey)
        
        let con = transitionContext.containerView
        
        // let r1start = transitionContext.initialFrame(for:vc1!)
        // let r2end = transitionContext.finalFrame(for:vc2!)
        
        let v1 = transitionContext.view(forKey:UITransitionContextFromViewKey)
        let v2 = transitionContext.view(forKey:UITransitionContextToViewKey)
        
        // we are using the same object (self) as animation controller
        // for both presentation and dismissal
        // so we have to distinguish the two cases
        
        if let v2 = v2 {
            con.addSubview(v2)
            let scale = CGAffineTransform(scaleX:1.6, y:1.6)
            v2.transform = scale
            v2.alpha = 0
            UIView.animate(withDuration:0.25, animations: {
                v2.alpha = 1
                v2.transform = .identity
                }, completion: {
                    _ in
                    transitionContext.completeTransition(true)
                })
        } else if let v1 = v1 {
            UIView.animate(withDuration:0.25, animations: {
                v1.alpha = 0
                }, completion: {
                    _ in
                    transitionContext.completeTransition(true)
                })
        }
        
    }

}
