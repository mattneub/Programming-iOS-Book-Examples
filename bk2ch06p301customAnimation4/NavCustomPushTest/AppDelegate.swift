
import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
        (self.window!.rootViewController as! UINavigationController).delegate = self
        return true
        
    }
}

// interesting unfortunate consequence of implementing our own push transition...
// we lose the built-in interactive pop transition

extension AppDelegate : UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return self
        }
        return nil
    }
}

extension AppDelegate : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let vc2 = transitionContext.viewController(forKey:UITransitionContextToViewControllerKey)!
        let con = transitionContext.containerView
        let r2end = transitionContext.finalFrame(for:vc2)
        let v2 = transitionContext.view(forKey:UITransitionContextToViewKey)!
        
        con.addSubview(v2)
        v2.frame = r2end
        v2.alpha = 0
        
        UIView.animate(withDuration:0.6, animations:{
            v2.alpha = 1
            }, completion: {
                _ in
                transitionContext.completeTransition(true)
            })
    }

}
