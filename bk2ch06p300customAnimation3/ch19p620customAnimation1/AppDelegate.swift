

import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {
    var window : UIWindow?
    var rightEdger : UIScreenEdgePanGestureRecognizer!
    var leftEdger : UIScreenEdgePanGestureRecognizer!
    var context : UIViewControllerContextTransitioning!
    var interacting = false
    var r1end = CGRectZero
    var r2start = CGRectZero
    
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
        // for this example, we are interactive _only_, and _we_ are the interactor
        return self.interacting ? self : nil
    }
    
    func tabBarController(tabBarController: UITabBarController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // no interaction if we didn't use g.r.
        return self.interacting ? self : nil
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
        
        var vc1 : UIViewController!
        var vc2 : UIViewController!
        // var con : UIView!
        var r1start : CGRect!
        var r2end : CGRect!
        var v1 : UIView!
        var v2 : UIView!
        
        let tc = self.context
        if tc != nil {
            
            vc1 = tc.viewControllerForKey(UITransitionContextFromViewControllerKey)!
            vc2 = tc.viewControllerForKey(UITransitionContextToViewControllerKey)!
            
            // con = tc.containerView()!
            
            r1start = tc.initialFrameForViewController(vc1)
            r2end = tc.finalFrameForViewController(vc2)
            
            v1 = tc.viewForKey(UITransitionContextFromViewKey)!
            v2 = tc.viewForKey(UITransitionContextToViewKey)!
            
        }
        
        switch g.state {
        case .Began:
            self.interacting = true
            if g == self.rightEdger {
                tbc.selectedIndex = tbc.selectedIndex + 1
            } else {
                tbc.selectedIndex = tbc.selectedIndex - 1
            }
        case .Changed:
            
            r1start.origin.x += (r1end.origin.x-r1start.origin.x)*percent
            v1.frame = r1start
            
            var r2start = self.r2start // copy
            r2start.origin.x += (r2end.origin.x-r2start.origin.x)*percent
            v2.frame = r2start
            
            tc.updateInteractiveTransition(percent)
            
        case .Ended:
            
            if percent > 0.5 {
                UIView.animateWithDuration(0.2, animations:{
                    v1.frame = self.r1end
                    v2.frame = r2end
                    }, completion: { _ in
                        tc.finishInteractiveTransition()
                        tc.completeTransition(true)
                })
            }
            else {
                UIView.animateWithDuration(0.2, animations:{
                    v1.frame = r1start
                    v2.frame = self.r2start
                    }, completion: { _ in
                        tc.cancelInteractiveTransition()
                        tc.completeTransition(false)
                })
            }
            
            self.interacting = false
            self.context = nil
        case .Cancelled:
            
            v1.frame = r1start
            v2.frame = r2start
            
            tc.cancelInteractiveTransition()
            tc.completeTransition(false)
            self.interacting = false
            self.context = nil
        default: break
        }
    }
}

extension AppDelegate : UIViewControllerInteractiveTransitioning {
    func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning){
        // store transition context so the gesture recognizer can get at it
        self.context = transitionContext
        
        // set up initial conditions
        let vc1 = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let vc2 = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let con = transitionContext.containerView()!
        
        let r1start = transitionContext.initialFrameForViewController(vc1)
        let r2end = transitionContext.finalFrameForViewController(vc2)
        
        // let v1 = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let v2 = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        // which way we are going depends on which vc is which
        // the most general way to express this is in terms of index number
        let tbc = self.window!.rootViewController as! UITabBarController
        let ix1 = tbc.viewControllers!.indexOf(vc1)!
        let ix2 = tbc.viewControllers!.indexOf(vc2)!
        let dir : CGFloat = ix1 < ix2 ? 1 : -1
        var r1end = r1start
        r1end.origin.x -= r1end.size.width * dir
        var r2start = r2end
        r2start.origin.x += r2start.size.width * dir
        v2.frame = r2start
        con.addSubview(v2)
        
        // record initial conditions so the gesture recognizer can get at them
        self.r1end = r1end
        self.r2start = r2start
    }
}

extension AppDelegate : UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
    }
}
