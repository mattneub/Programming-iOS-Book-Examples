

import UIKit

class FirstViewController : UIViewController {}
class SecondViewController : UIViewController {}

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    var anim : UIViewImplicitlyAnimating?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        (self.window!.rootViewController as! UITabBarController).delegate = self
        
        return true
    }
}

extension AppDelegate {
    @objc func buttonTap(_ sender: Any) {
        print("tap!") // testing whether user can interact during animation
        // nope, looks like everything is okay
    }
}

extension AppDelegate : UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension AppDelegate : UIViewControllerAnimatedTransitioning {
    
    func interruptibleAnimator(using ctx: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        
        // the trick is that this method may be called multiple times
        // (it won't be in this example, but I'm trying to establish a general use pattern)
        // so we use a property self.anim to establish a singleton for the life of the animation
        
        if self.anim != nil {
            return self.anim! // *
        }
        
        let vc1 = ctx.viewController(forKey:.from)! // 3
        let vc2 = ctx.viewController(forKey:.to)!
        
        let con = ctx.containerView
        print(con)
        
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
        anim.addCompletion { _ in
            ctx.completeTransition(true)
        }
        
        self.anim = anim // *
        print("creating animator")
        return anim
    }

    
    func transitionDuration(using ctx: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4 // 1
    }
    
    func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        let anim = self.interruptibleAnimator(using: ctx) // 2
        anim.startAnimation()
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        print("ended") // called twice??
        // cleanup!
        self.anim = nil
    }
}
