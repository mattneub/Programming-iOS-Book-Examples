

import UIKit

func delay(_ delay:Double, closure:()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {
    var window : UIWindow?

    var inter : UIPercentDrivenInteractiveTransition!
    var anim : UIViewImplicitlyAnimating?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let tbc = self.window!.rootViewController as! UITabBarController
        tbc.delegate = self
        
        // edges problem is gone, no longer retain ref to g.r.
        
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
    
    func doButton(_ sender: AnyObject) {
        print("button tap!")
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.inter // will be nil if we didn't use g.r.
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
    
    func pan(_ g:UIScreenEdgePanGestureRecognizer) {
        let v = g.view!
        // according to the docs, calling self.inter.update(percent)
        // should update the percent driver's percentComplete
        // but it doesn't; the percentComplete is always zero
        // so I have to do the calculation every time, so that .changed and .ended
        // can both see it
        let delta = g.translation(in:v)
        let percent = abs(delta.x/v.bounds.size.width)

        switch g.state {
        case .began:
            self.inter = UIPercentDrivenInteractiveTransition()
            // see animationEnded for cleanup
            let tbc = self.window!.rootViewController as! UITabBarController
            if g.edges == .right {
                tbc.selectedIndex = tbc.selectedIndex + 1
            } else {
                tbc.selectedIndex = tbc.selectedIndex - 1
            }
            fallthrough
        case .changed:
            self.inter.update(percent)
        case .ended:
            // self.inter.completionSpeed = 0.5
            // (try completionSpeed = 2 to see "ghosting" problem after a partial)
            // (can occur with 1 as well)
            // (setting to 0.5 seems to fix it)
            // now using delay in completion handler to solve the issue
            print(self.inter.percentComplete) // zero, that's a bug
            if percent > 0.5 {
                self.inter.finish()
            } else {
                self.inter.cancel()
            }
        case .cancelled:
            self.inter.cancel()
        default: break
        }
    }
}

extension AppDelegate : UIViewControllerAnimatedTransitioning {
    
    // called if we are interactive (by percent driver)
    func interruptibleAnimator(using ctx: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        
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
        anim.addCompletion { _ in
            let cancelled = ctx.transitionWasCancelled
            ctx.completeTransition(!cancelled)
        }
        
        self.anim = anim
        print("creating animator")
        return anim
    }

    func transitionDuration(using ctx: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    // called if we are not interactive
    func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        
        let anim = self.interruptibleAnimator(using: ctx)
        anim.startAnimation()
        
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        print("animation ended")
        self.inter = nil // * cleanup!
        self.anim = nil
    }
}
