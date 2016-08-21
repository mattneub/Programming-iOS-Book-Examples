

import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {
    var window : UIWindow?
    var context : UIViewControllerContextTransitioning? // * phasing out misuse of IUO
    var interacting = false
    
    var anim : UIViewImplicitlyAnimating? // cannot be weak, vanishes before end of gesture
    
    var prev : UIPreviewInteraction! // *
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
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
        
        let prev = UIPreviewInteraction(view: tbc.view)
        prev.delegate = self
        self.prev = prev
        
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("animation controller")
        return self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        print("interaction controller")
        return self.interacting ? self : nil
    }
    
}

extension AppDelegate : UIPreviewInteractionDelegate {
    func previewInteractionShouldBegin(_ previewInteraction: UIPreviewInteraction) -> Bool {
        let tbc = self.window!.rootViewController as! UITabBarController
        let loc = previewInteraction.location(in:tbc.view)
        if tbc.tabBar.frame.contains(loc) {
            return false // don't conflict with buttons
        }
        if loc.x > tbc.view!.bounds.midX {
            if tbc.selectedIndex < tbc.viewControllers!.count - 1 {
                self.interacting = true
                tbc.selectedIndex = tbc.selectedIndex + 1
                tbc.tabBar.isUserInteractionEnabled = false
                return true
            }
        } else {
            if tbc.selectedIndex > 0 {
                self.interacting = true
                tbc.selectedIndex = tbc.selectedIndex - 1
                tbc.tabBar.isUserInteractionEnabled = false
                return true
            }
        }
        return false
    }
    
    func previewInteraction(_ previewInteraction: UIPreviewInteraction, didUpdatePreviewTransition transitionProgress: CGFloat, ended: Bool) {
        var percent = transitionProgress
        // clamp so that we cannot reach either 0 or 1...
        // because we don't want to end the animation by setting its fractionComplete
        if percent < 0.05 {percent = 0.05}
        if percent > 0.95 {percent = 0.95}
        print(percent)
        self.anim?.fractionComplete = percent
        self.context?.updateInteractiveTransition(percent)
    }
    
    func previewInteraction(_ previewInteraction: UIPreviewInteraction, didUpdateCommitTransition transitionProgress: CGFloat, ended: Bool) {
        if ended {
            self.anim?.pauseAnimation()
            self.anim?.stopAnimation(false)
            self.anim?.finishAnimation(at: .end)
            let tbc = self.window!.rootViewController as! UITabBarController
            tbc.tabBar.isUserInteractionEnabled = true
        }
    }
    
    func previewInteractionDidCancel(_ previewInteraction: UIPreviewInteraction) {
        if let anim = self.anim as? UIViewPropertyAnimator {
            anim.pauseAnimation()
            anim.isReversed = true
            anim.continueAnimation(
                withTimingParameters:
                UICubicTimingParameters(animationCurve:.linear),
                durationFactor: 0.2)
            let tbc = self.window!.rootViewController as! UITabBarController
            tbc.tabBar.isUserInteractionEnabled = true
        }
    }

}

extension AppDelegate : UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ g: UIGestureRecognizer) -> Bool {
        return false // turn this off entirely
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
    
    func pan(_ g:UIScreenEdgePanGestureRecognizer) {
        
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
        // store transition context so the gesture recognizer can get at it
        self.context = ctx
        
        // store the animator so the gesture recognizer can get at it
        self.anim = self.interruptibleAnimator(using: ctx)
        
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
        
        let vc1 = ctx.viewController(forKey:UITransitionContextFromViewControllerKey)!
        let vc2 = ctx.viewController(forKey:UITransitionContextToViewControllerKey)!
        
        let con = ctx.containerView
        
        let r1start = ctx.initialFrame(for:vc1)
        let r2end = ctx.finalFrame(for:vc2)
        
        // new in iOS 8, use these instead of assuming that the views are the views of the vcs
        let v1 = ctx.view(forKey:UITransitionContextFromViewKey)!
        let v2 = ctx.view(forKey:UITransitionContextToViewKey)!
        
        // which way we are going depends on which vc is which
        // the most general way to express this is in terms of index number
        let tbc = self.window!.rootViewController as! UITabBarController
        let ix1 = tbc.viewControllers!.index(of:vc1)!
        let ix2 = tbc.viewControllers!.index(of:vc2)!
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
