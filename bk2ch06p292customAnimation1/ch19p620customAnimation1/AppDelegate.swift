

import UIKit

class FirstViewController : UIViewController {}
class SecondViewController : UIViewController {}

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        (self.window!.rootViewController as! UITabBarController).delegate = self
        
        return true
    }
}

extension AppDelegate : UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension AppDelegate : UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(_ transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    func animateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        let vc1 = transitionContext.viewController(forKey:UITransitionContextFromViewControllerKey)!
        let vc2 = transitionContext.viewController(forKey:UITransitionContextToViewControllerKey)!
        
        let con = transitionContext.containerView()!
        print(con)
        
        let r1start = transitionContext.initialFrame(for:vc1)
        let r2end = transitionContext.finalFrame(for:vc2)
        
        // new in iOS 8, use these instead of assuming that the views are the views of the vcs
        let v1 = transitionContext.view(forKey:UITransitionContextFromViewKey)!
        let v2 = transitionContext.view(forKey:UITransitionContextToViewKey)!
        
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
        
        UIApplication.shared().beginIgnoringInteractionEvents()
        UIView.animate(withDuration:0.4, animations: {
            v1.frame = r1end
            v2.frame = r2end
            }, completion: {
                _ in
                transitionContext.completeTransition(true)
                UIApplication.shared().endIgnoringInteractionEvents()
            })
    }
}
