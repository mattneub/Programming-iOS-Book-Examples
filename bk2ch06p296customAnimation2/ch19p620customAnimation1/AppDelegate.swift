

import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {
    var window : UIWindow?
    var rightEdger : UIScreenEdgePanGestureRecognizer!
    var leftEdger : UIScreenEdgePanGestureRecognizer!
    var inter : UIPercentDrivenInteractiveTransition!
    var interacting = false
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let tbc = self.window!.rootViewController as! UITabBarController
        tbc.delegate = self
        
        // keep ref to g.r.s, because can't learn which one it is by asking for "edges" later
        // (always comes back as None)
        
        let sep = UIScreenEdgePanGestureRecognizer(target:self, action:"pan:")
        sep.edges = UIRectEdge.Right
        tbc.view.addGestureRecognizer(sep)
        sep.delegate = self
        self.rightEdger = sep
        
        let sep2 = UIScreenEdgePanGestureRecognizer(target:self, action:"pan:")
        sep2.edges = UIRectEdge.Left
        tbc.view.addGestureRecognizer(sep2)
        sep2.delegate = self
        self.leftEdger = sep2
        
        return true
    }
    
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func tabBarController(tabBarController: UITabBarController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        let result : UIViewControllerInteractiveTransitioning? = self.interacting ? self.inter : nil
        // no interaction if we didn't use g.r.
        return result
    }
}

extension AppDelegate : UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(g: UIGestureRecognizer) -> Bool {
        let tbc = self.window!.rootViewController as! UITabBarController
        var result = false
        
        if g == self.rightEdger {
            result = (tbc.selectedIndex < tbc.viewControllers!.count - 1)
        }
        else {
            result = (tbc.selectedIndex > 0)
        }
        return result
    }
    
    func pan(g:UIScreenEdgePanGestureRecognizer) {
        let v = g.view!
        let tbc = self.window!.rootViewController as! UITabBarController
        let delta = g.translationInView(v)
        let percent = fabs(delta.x/v.bounds.size.width)
        switch g.state {
        case .Began:
            self.inter = UIPercentDrivenInteractiveTransition()
            self.interacting = true
            if g == self.rightEdger {
                tbc.selectedIndex = tbc.selectedIndex + 1
            } else {
                tbc.selectedIndex = tbc.selectedIndex - 1
            }
        case .Changed:
            self.inter.updateInteractiveTransition(percent)
        case .Ended:
            // self.inter.completionSpeed = 0.5
            // (try completionSpeed = 2 to see "ghosting" problem after a partial)
            // (can occur with 1 as well)
            // (setting to 0.5 seems to fix it)
            // now using delay in completion handler to solve the issue
            
            if percent > 0.5 {
                self.inter.finishInteractiveTransition()
            } else {
                self.inter.cancelInteractiveTransition()
            }
            self.interacting = false
        case .Cancelled:
            self.inter.cancelInteractiveTransition()
            self.interacting = false
        default: break
        }
    }
}

extension AppDelegate : UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let vc1 = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let vc2 = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let con = transitionContext.containerView()
        
        let r1start = transitionContext.initialFrameForViewController(vc1)
        let r2end = transitionContext.finalFrameForViewController(vc2)
        
        // new in iOS 8, use these instead of assuming that the views are the views of the vcs
        let v1 = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let v2 = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        // which way we are going depends on which vc is which
        // the most general way to express this is in terms of index number
        let tbc = self.window!.rootViewController as! UITabBarController
        let ix1 = find(tbc.viewControllers as! [UIViewController], vc1)
        let ix2 = find(tbc.viewControllers as! [UIViewController], vc2)
        let dir : CGFloat = ix1 < ix2 ? 1 : -1
        var r1end = r1start
        r1end.origin.x -= r1end.size.width * dir
        var r2start = r2end
        r2start.origin.x += r2start.size.width * dir
        v2.frame = r2start
        con.addSubview(v2)
        
        // interaction looks much better if animation curve is linear
        var opts : UIViewAnimationOptions = self.interacting ? .CurveLinear : nil
        
        if !self.interacting {
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        }
        UIView.animateWithDuration(0.4, delay:0, options:opts, animations: {
            v1.frame = r1end
            v2.frame = r2end
            }, completion: {
                _ in
                delay (0.1) { // needed to solve "black ghost" problem after partial gesture
                    let cancelled = transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(!cancelled)
                    if UIApplication.sharedApplication().isIgnoringInteractionEvents() {
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    }
                }
            })
    }
}
