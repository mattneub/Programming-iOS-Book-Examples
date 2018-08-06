

import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    var context : UIViewControllerContextTransitioning? // * phasing out misuse of IUO
    var interacting = false
    var anim : UIViewImplicitlyAnimating? // cannot be weak, vanishes before end of gesture
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        let tbc = self.window!.rootViewController as! UITabBarController
        tbc.delegate = self
        
        
        let sep = UIScreenEdgePanGestureRecognizer(target:self, action:#selector(pan))
        sep.edges = UIRectEdge.right
        tbc.view.addGestureRecognizer(sep)
        sep.delegate = self
        
        let sep2 = UIScreenEdgePanGestureRecognizer(target:self, action:#selector(pan))
        sep2.edges = UIRectEdge.left
        tbc.view.addGestureRecognizer(sep2)
        sep2.delegate = self
        
        return true
    }
    
}

extension AppDelegate: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("animation controller")
        return self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        print("interaction controller")
        return self.interacting ? self : nil
    }
}

extension AppDelegate : UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ g: UIGestureRecognizer) -> Bool {
        let tbc = self.window!.rootViewController as! UITabBarController
        var result = false
        
        if (g as! UIScreenEdgePanGestureRecognizer).edges == .right {
            result = (tbc.selectedIndex < tbc.viewControllers!.count - 1)
        }
        else {
            result = (tbc.selectedIndex > 0)
        }
        return result
    }
    
    @objc func pan(_ g:UIScreenEdgePanGestureRecognizer) {
        
        switch g.state {
        case .began:
            self.interacting = true
            let tbc = self.window!.rootViewController as! UITabBarController
            if g.edges == .right {
                tbc.selectedIndex = tbc.selectedIndex + 1
            } else {
                tbc.selectedIndex = tbc.selectedIndex - 1
            }
        case .changed:
            let v = g.view!
            let delta = g.translation(in:v)
            let percent = abs(delta.x/v.bounds.size.width)
            self.anim?.fractionComplete = percent
            self.context?.updateInteractiveTransition(percent)
        case .ended:
            
            // this is the money shot!
            // with a property animator, the whole notion of "hurry home" is easy -
            // including "hurry back to start"
            
            let anim = self.anim as! UIViewPropertyAnimator
            anim.pauseAnimation()

            if anim.fractionComplete < 0.5 {
                anim.isReversed = true
            }
            anim.continueAnimation(
                withTimingParameters:
                UICubicTimingParameters(animationCurve:.linear),
                durationFactor: 0.2)

        case .cancelled:
            
            self.anim?.pauseAnimation()
            self.anim?.stopAnimation(false)
            self.anim?.finishAnimation(at: .start)
            
        default: break
        }
    }
}

extension AppDelegate : UIViewControllerInteractiveTransitioning {
    
    // called if we are interactive
    // (because we now have no percent driver)
    func startInteractiveTransition(_ ctx: UIViewControllerContextTransitioning){
        print("startInteractiveTransition")
        
        // store the animator so the gesture recognizer can get at it
        self.anim = self.interruptibleAnimator(using: ctx)
        
        // store transition context so the gesture recognizer can get at it
        self.context = ctx
        
        // I don't like having to store them both
        // I could make this look neater with a "helper object"
        // but really, they ought to give me nicer way
        
    }
}

extension AppDelegate : UIViewControllerAnimatedTransitioning {
    
    func interruptibleAnimator(using ctx: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        print("interruptibleAnimator")
        
        if self.anim != nil {
            return self.anim!
        }
        
        let vc1 = ctx.viewController(forKey:.from)!
        let vc2 = ctx.viewController(forKey:.to)!
        
        let con = ctx.containerView
        
        let r1start = ctx.initialFrame(for:vc1)
        let r2end = ctx.finalFrame(for:vc2)
        
        // new in iOS 8, use these instead of assuming that the views are the views of the vcs
        let v1 = ctx.view(forKey:.from)!
        let v2 = ctx.view(forKey:.to)!
        
        // which way we are going depends on which vc is which
        // the most general way to express this is in terms of index number
        let tbc = self.window!.rootViewController as! UITabBarController
        let ix1 = tbc.viewControllers!.firstIndex(of:vc1)!
        let ix2 = tbc.viewControllers!.firstIndex(of:vc2)!
        let dir : CGFloat = ix1 < ix2 ? 1 : -1
        var r1end = r1start
        r1end.origin.x -= r1end.size.width * dir
        var r2start = r2end
        r2start.origin.x += r2start.size.width * dir
        v2.frame = r2start
        con.addSubview(v2)
        
        let anim = UIViewPropertyAnimator(duration: 0.4, curve: .linear) {
            v1.frame = r1end
            v2.frame = r2end
        }
        anim.addCompletion { finish in 
            if finish == .end {
                ctx.finishInteractiveTransition()
                ctx.completeTransition(true)
            } else {
                ctx.cancelInteractiveTransition()
                ctx.completeTransition(false)
            }
        }
        
        self.anim = anim
        print("creating animator")
        return anim
    }
    
    func transitionDuration(using ctx: UIViewControllerContextTransitioning?) -> TimeInterval {
        print("transitionDuration")
        return 0.4
    }
    
    // called if we are not interactive
    func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        print("animateTransition")
        
        let anim = self.interruptibleAnimator(using: ctx)
        anim.startAnimation()
        
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        print("animation ended")
        // reset everything
        self.interacting = false
        self.context = nil
        self.anim = nil
    }
}
