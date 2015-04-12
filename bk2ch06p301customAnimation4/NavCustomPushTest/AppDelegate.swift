
import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
        (self.window!.rootViewController as! UINavigationController).delegate = self
        return true
        
    }
}

// interesting unfortunate consequence of implementing our own push transition...
// we lose the built-in interactive pop transition

extension AppDelegate : UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .Push {
            return self
        }
        return nil
    }
}

extension AppDelegate : UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval{
        return 0.6
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let vc2 = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let con = transitionContext.containerView()
        let r2end = transitionContext.finalFrameForViewController(vc2)
        let v2 = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        con.addSubview(v2)
        v2.frame = r2end
        v2.alpha = 0
        
        UIView.animateWithDuration(0.6, animations:{
            v2.alpha = 1
            }, completion: {
                _ in
                transitionContext.completeTransition(true)
            })
    }

}
