
import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    var anim : UIViewImplicitlyAnimating?
    var context : UIViewControllerContextTransitioning?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
    
        (self.window!.rootViewController as! UINavigationController).delegate = self
        return true
        
    }
}

extension AppDelegate : UINavigationControllerDelegate {
    // comment out this whole function to restore the default pop gesture
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return self
        }
        return nil
    }
//    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return nil
//    }
}

// simple example of interruptibility
// user can grab image as it grows and drag it around
// we just resume when user lets go
extension AppDelegate {
    @objc func drag (_ g : UIPanGestureRecognizer) {
        let v = g.view!
        switch g.state {
        case .began:
            self.anim?.pauseAnimation()
            fallthrough
        case .changed:
            let delta = g.translation(in:v.superview)
            var c = v.center
            c.x += delta.x; c.y += delta.y
            v.center = c
            g.setTranslation(.zero, in: v.superview)
        case .ended, .cancelled:
            let anim = self.anim as! UIViewPropertyAnimator
            // this is the tricky part; the existing animation no longer works...
            // ...because the snapshot view being animated has moved
            // therefore we have to add a new animation that does the same thing from here
            let ctx = self.context!
            let vc2 = ctx.viewController(forKey:.to)!
            anim.addAnimations {
                v.frame = ctx.finalFrame(for: vc2)
            }
            anim.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:break
        }
    }
}

extension AppDelegate : UIViewControllerAnimatedTransitioning {
    
    func interruptibleAnimator(using ctx: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        
        if self.anim != nil {
            return self.anim!
        }
        
        let vc1 = ctx.viewController(forKey:.from)!
        let vc2 = ctx.viewController(forKey:.to)!
        let con = ctx.containerView
        let r2end = ctx.finalFrame(for:vc2)
        let v2 = ctx.view(forKey:.to)!
        
        
        let mvc = vc1 as! MasterViewController
        let tv = mvc.tableView!
        let r = tv.rectForRow(at: IndexPath(row: 0, section: 0))
        let r2 = con.convert(r, from: tv)
        
        v2.frame = r2end
        
        con.addSubview(v2)
        
        let cm = mvc.model[mvc.lastSelection.row]
        let snapshot = UIImageView(image:UIImage(named:cm.name))
        snapshot.contentMode = .scaleAspectFill
        snapshot.clipsToBounds = true
        
        snapshot.frame = r2
        
        con.addSubview(snapshot)
        
        v2.alpha = 0
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(drag))
        snapshot.addGestureRecognizer(pan)
        snapshot.isUserInteractionEnabled = true
        
        let anim = UIViewPropertyAnimator(duration: 2, curve: .linear) {
            snapshot.frame = r2end // I'm sort of cheating; I know it will fill its superview
        }
        
        anim.addCompletion { _ in
            ctx.completeTransition(true)
            v2.alpha = 1
            snapshot.removeFromSuperview()
        }
        
        self.anim = anim
        print("creating animator")
        self.context = ctx
        
        return anim
    }
    
    func transitionDuration(using ctx: UIViewControllerContextTransitioning?) -> TimeInterval{
        return 2
    }
    
    func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        let anim = self.interruptibleAnimator(using: ctx)
        anim.startAnimation()
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        print("animation ended")
        self.anim = nil
        self.context = nil
    }

}
