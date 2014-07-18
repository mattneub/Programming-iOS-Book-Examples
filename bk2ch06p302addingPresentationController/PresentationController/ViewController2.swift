

import UIKit
import QuartzCore

class ViewController2: UIViewController {
    // important: viewDidLoad() is too late for this sort of thing
    // must be done before presentation even has a chance to start
    init(coder aDecoder: NSCoder!) {
        super.init(coder:aDecoder)
        // customize presentation only on iPhone
        // how will we find out which it is? we have no traitCollection yet...
        // I know, let's ask the window
        if UIApplication.sharedApplication().keyWindow.traitCollection.userInterfaceIdiom == .Phone {
            self.transitioningDelegate = self
            self.modalPresentationStyle = .Custom
        }
    }
    
    @IBAction func doButton(sender: AnyObject) {
        self.presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ViewController2 : UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController(presented: UIViewController!, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController!) -> UIPresentationController! {
        let pc = MyPresentationController(presentingViewController: presenting, presentedViewController: presented)
        return pc
    }
}

class MyPresentationController : UIPresentationController {
    override func frameOfPresentedViewInContainerView() -> CGRect {
        return super.frameOfPresentedViewInContainerView().rectByInsetting(dx: 40, dy: 40)
    }
}

// comment out what follows and then add it back incrementally

// ==========================

extension MyPresentationController {
    override func presentationTransitionWillBegin() {
        let con = self.containerView
        let shadow = UIView(frame:con.bounds)
        shadow.backgroundColor = UIColor(white:0, alpha:0.4)
        con.insertSubview(shadow, atIndex: 0)
        // deal with what happens on rotation
        shadow.autoresizingMask = .FlexibleWidth | .FlexibleHeight
    }
}

// ==========================

extension MyPresentationController {
    override func dismissalTransitionWillBegin() {
        let con = self.containerView
        let shadow = (con.subviews as [UIView])[0]
        let tc = self.presentedViewController.transitionCoordinator()
        tc.animateAlongsideTransition({
            _ in
            shadow.alpha = 0
            }, completion: nil)
    }
}

// ===========================

extension MyPresentationController {
    override func presentedView() -> UIView! {
        let v = super.presentedView()
        v.layer.cornerRadius = 6
        v.layer.masksToBounds = true
        return v
    }
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

