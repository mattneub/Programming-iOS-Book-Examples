

import UIKit

class Animator : NSObject {
    var anim : UIViewImplicitlyAnimating?
    unowned var tbc : UITabBarController
    init(tabBarController tbc: UITabBarController) {
        self.tbc = tbc
    }
}

extension Animator : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension Animator : UIViewControllerAnimatedTransitioning {
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
        let ix1 = self.tbc.viewControllers!.firstIndex(of:vc1)!
        let ix2 = self.tbc.viewControllers!.firstIndex(of:vc2)!
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
        print("ended") // called twice?? I've no idea why but no harm done
        // cleanup!
        self.anim = nil
    }
}

