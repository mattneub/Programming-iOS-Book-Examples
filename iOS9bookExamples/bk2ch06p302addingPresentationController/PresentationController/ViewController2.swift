

import UIKit


class ViewController2: UIViewController {
    @IBOutlet weak var buttonTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var button: UIButton!
    
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
        if UIApplication.sharedApplication().keyWindow!.traitCollection.userInterfaceIdiom == .Phone {
            self.modalPresentationStyle = .Custom
        }
    }
    
    @IBAction func doButton(sender: AnyObject) {
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ViewController2 : UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let pc = MyPresentationController(presentedViewController: presented, presentingViewController: presenting)
        return pc
    }
}

class MyPresentationController : UIPresentationController {
    override func frameOfPresentedViewInContainerView() -> CGRect {
        return super.frameOfPresentedViewInContainerView().insetBy(dx: 40, dy: 40)
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
        con.insertSubview(shadow, atIndex: 0)
        // deal with what happens on rotation
        shadow.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    }
}

// ==========================

extension MyPresentationController {
    override func dismissalTransitionWillBegin() {
        let con = self.containerView!
        let shadow = con.subviews[0]
        let tc = self.presentedViewController.transitionCoordinator()!
        tc.animateAlongsideTransition({
            _ in
            shadow.alpha = 0
            }, completion: nil)
    }
}


// ===========================

extension MyPresentationController {
    override func presentedView() -> UIView? {
        let v = super.presentedView()!
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
    override func presentationTransitionDidEnd(completed: Bool) {
        let vc = self.presentingViewController
        let v = vc.view
        v.tintAdjustmentMode = .Dimmed
    }
    override func dismissalTransitionDidEnd(completed: Bool) {
        let vc = self.presentingViewController
        let v = vc.view
        v.tintAdjustmentMode = .Automatic
    }
}


// ==========================

extension ViewController2 /* UIViewControllerTransitioningDelegate */ {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // return nil
        return self
    }
}

extension ViewController2 : UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // let vc1 = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let vc2 = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let con = transitionContext.containerView()!
        
        // let r1start = transitionContext.initialFrameForViewController(vc1!)
        let r2end = transitionContext.finalFrameForViewController(vc2!)
        
        //let v1 = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let v2 = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        v2.frame = r2end
        v2.transform = CGAffineTransformMakeScale(0.1, 0.1)
        v2.alpha = 0
        con.addSubview(v2)
        
        UIView.animateWithDuration(0.4, animations: {
            v2.alpha = 1
            v2.transform = CGAffineTransformIdentity
            }, completion: {
                _ in
                transitionContext.completeTransition(true)
            })
        
    }
}

// =======

extension ViewController2 {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let tc = self.transitionCoordinator() {
            tc.animateAlongsideTransition({
                _ in
                self.buttonTopConstraint.constant += 200
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}


