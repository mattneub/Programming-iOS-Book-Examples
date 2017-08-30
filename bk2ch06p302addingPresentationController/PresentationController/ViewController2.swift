

import UIKit


class ViewController2: UIViewController {
    @IBOutlet weak var buttonTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var button: UIButton!
    
    var anim : UIViewImplicitlyAnimating?
    
    // important: viewDidLoad() is too late for this sort of thing
    // must be done before presentation even has a chance to start
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        // NB if we want to modify the _animation_, we need to set the transitioningDelegate
        self.transitioningDelegate = self
        // if we want to modify the _presentation_, we need to set the style to custom
        // customize presentation only on iPhone
        // how will we find out which it is? we have no traitCollection yet...
        // I know, let's ask the window
        if UIApplication.shared.keyWindow!.traitCollection.userInterfaceIdiom == .phone {
            self.modalPresentationStyle = .custom
        }
    }
    
    @IBAction func doButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated:true)
    }
}

extension ViewController2 : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let pc = MyPresentationController(presentedViewController: presented, presenting: presenting)
        return pc
    }
}

class MyPresentationController : UIPresentationController {
    override var frameOfPresentedViewInContainerView : CGRect {
        return super.frameOfPresentedViewInContainerView.insetBy(dx: 40, dy: 40)
    }
}

// comment out what follows and then add it back incrementally
/*
The moral here is:
(1) The separation into presentation controller and animation controller is ***great***!
(2) Your eyes may glaze over at all the classes/protocols in the documentation, 
but if you just add the pieces one by one
it all makes perfect sense
*/


// ==========================

extension MyPresentationController {
    override func presentationTransitionWillBegin() {
        let con = self.containerView!
        let shadow = UIView(frame:con.bounds)
        shadow.backgroundColor = UIColor(white:0, alpha:0.4)
        con.insertSubview(shadow, at: 0)
        // deal with what happens on rotation
        shadow.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

// ==========================

extension MyPresentationController {
    override func dismissalTransitionWillBegin() {
        let con = self.containerView!
        let shadow = con.subviews[0]
        let tc = self.presentedViewController.transitionCoordinator!
        tc.animate(alongsideTransition: {
            _ in
            shadow.alpha = 0
            })
    }
}


// ===========================

extension MyPresentationController {
    override var presentedView : UIView? {
        let v = super.presentedView!
        v.layer.cornerRadius = 6
        v.layer.masksToBounds = true
        return v
    }
//    override func shouldRemovePresentersView() -> Bool {
//        return true
//    }
}


// ===========================

extension MyPresentationController {
    override func presentationTransitionDidEnd(_ completed: Bool) {
        let vc = self.presentingViewController
        let v = vc.view
        v?.tintAdjustmentMode = .dimmed
    }
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        let vc = self.presentingViewController
        let v = vc.view
        v?.tintAdjustmentMode = .automatic
    }
}


// ==========================

extension ViewController2 /*: UIViewControllerTransitioningDelegate*/ {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // return nil
        return self
    }
}

extension ViewController2 : UIViewControllerAnimatedTransitioning {
    
    func interruptibleAnimator(using ctx: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
    
        if self.anim != nil {
            return self.anim!
        }
        
        // let vc1 = transitionContext.viewController(forKey:.from)
        let vc2 = ctx.viewController(forKey:.to)
        
        let con = ctx.containerView
        
        // let r1start = transitionContext.initialFrame(for:vc1!)
        let r2end = ctx.finalFrame(for:vc2!)
        
        //let v1 = transitionContext.view(forKey:.from)!
        let v2 = ctx.view(forKey:.to)!
        
        v2.frame = r2end
        v2.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        v2.alpha = 0
        con.addSubview(v2)
        
        let anim = UIViewPropertyAnimator(duration: 0.4, curve: .linear) {
            v2.alpha = 1
            v2.transform = .identity
        }
        anim.addCompletion { _ in
            ctx.completeTransition(true)
        }
        
        self.anim = anim
        return anim
    
    }
    
    func transitionDuration(using ctx: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        let anim = self.interruptibleAnimator(using: ctx)
        anim.startAnimation()
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        self.anim = nil
    }
}

// =======

extension ViewController2 {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tc = self.transitionCoordinator {
            tc.animate(alongsideTransition:{
                _ in
//                self.buttonTopConstraint.constant += 200
//                self.view.layoutIfNeeded()
            })
        }
    }
}


