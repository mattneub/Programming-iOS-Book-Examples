
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


// for comparison purposes
//        let alert = UIAlertController(title: "Howdy", message: "This is a test", preferredStyle: .Alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .Cancel))
//        self.present(alert, animated:true)
//        return;


class ViewController : UIViewController {
    @IBAction func doButton(_ sender: Any?) {
        self.present(ViewController2(), animated:true)
    }
}

// imitate an alert view

class ViewController2 : UIViewController {
    @IBOutlet var button : UIButton!
    
    @IBAction func doButton(_ sender: Any?) {
        self.presentingViewController?.dismiss(animated:true)
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
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
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

extension ViewController2 /*: UIViewControllerTransitioningDelegate */ {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("providing presentation animation controller")
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("providing dismissal animation controller")
        return self
    }
}

extension ViewController2 : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using ctx: UIViewControllerContextTransitioning?)
        -> TimeInterval {
            return 0.25
    }
    
    func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        // just for logging purposes
        let vc1 = ctx.viewController(forKey:.from)
        let vc2 = ctx.viewController(forKey:.to)
        print("vc1 is", type(of: vc1!), "\nvc2 is", type(of: vc2!))
        
        let con = ctx.containerView
        
        // let r1start = ctx.initialFrame(for:vc1!)
        // let r2end = ctx.finalFrame(for:vc2!)
        
        let v1 = ctx.view(forKey:.from)
        let v2 = ctx.view(forKey:.to)
        
        // we are using the same object (self) as animation controller
        // for both presentation and dismissal
        // so we have to distinguish the two cases
        // warning: this trick works only for non-fullscreen
        
        if let v2 = v2 { // presenting
            print("presentation animation")
            con.addSubview(v2)
            let scale = CGAffineTransform(scaleX:1.6, y:1.6)
            v2.transform = scale
            v2.alpha = 0
            UIView.animate(withDuration:0.25, animations: {
                v2.alpha = 1
                v2.transform = .identity
                }, completion: {
                    _ in
                    ctx.completeTransition(true)
                })
        } else if let v1 = v1 { // dismissing
            print("dismissal animation")
            UIView.animate(withDuration:0.25, animations: {
                v1.alpha = 0
                }, completion: {
                    _ in
                    ctx.completeTransition(true)
                })
        }
        
    }

}
