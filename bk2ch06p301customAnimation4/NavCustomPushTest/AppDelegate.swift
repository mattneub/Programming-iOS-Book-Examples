
import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    var anim : UIViewImplicitlyAnimating?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
        (self.window!.rootViewController as! UINavigationController).delegate = self
        return true
        
    }
}

extension AppDelegate : UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return self
        }
        return nil
    }
}

extension AppDelegate : UIViewControllerAnimatedTransitioning {
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        
        if self.anim != nil {
            return self.anim!
        }
        
        let vc1 = transitionContext.viewController(forKey:UITransitionContextFromViewControllerKey)!
        let vc2 = transitionContext.viewController(forKey:UITransitionContextToViewControllerKey)!
        let con = transitionContext.containerView
        let r2end = transitionContext.finalFrame(for:vc2)
        let v2 = transitionContext.view(forKey:UITransitionContextToViewKey)!
        
        
        let tvc = vc1 as! UITableViewController
        let tv = tvc.tableView!
        let r = tv.rectForRow(at: IndexPath(row: 0, section: 0))
        let r2 = con.convert(r, from: tv)
        
        v2.frame = r2end
        
        con.addSubview(v2)
        
        
        
        let rr = UIGraphicsImageRenderer(bounds: v2.frame)
        let im = rr.image { ctx in
            v2.layer.render(in: ctx.cgContext)
        }
        let snapshot = UIImageView(image:im)
        snapshot.contentMode = .scaleToFill
        snapshot.clipsToBounds = true
        
        snapshot.frame = r2
        
        con.addSubview(snapshot)
        
        v2.alpha = 0
        
        
        let anim = UIViewPropertyAnimator(duration: 0.6, curve: .linear) {
            snapshot.frame = r2end
        }
        
        anim.addCompletion { _ in
            transitionContext.completeTransition(true)
            v2.alpha = 1
            snapshot.removeFromSuperview()
        }
        
        
        self.anim = anim
        print("creating animator")
        return anim
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let anim = self.interruptibleAnimator(using: transitionContext)
        anim.startAnimation()
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        print("animation ended")
        self.anim = nil
    }

}
