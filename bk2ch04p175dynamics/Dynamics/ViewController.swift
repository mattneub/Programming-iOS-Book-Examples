
import UIKit

class ViewController : UIViewController {
    
    @IBOutlet var iv : UIImageView
    var anim : UIDynamicAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.anim = UIDynamicAnimator(referenceView: self.view)
        self.anim.delegate = self
    }
    
    @IBAction func doButton(sender:AnyObject?) {
        (sender as UIButton).enabled = false
        
        let grav = UIGravityBehavior()
        grav.action = {
            let items = self.anim.itemsInRect(self.view.bounds) as [UIView]
            let ix = find(items, self.iv)
            if !ix {
                self.anim.removeAllBehaviors()
                self.iv.removeFromSuperview()
                println("done")
            }
        }
        self.anim.addBehavior(grav)
        grav.addItem(self.iv)
        
        // ========
        
        let push = UIPushBehavior(items:[self.iv], mode:.Instantaneous)
        push.pushDirection = CGVectorMake(2, 0)
        // [push setTargetOffsetFromCenter:UIOffsetMake(0, -200) forItem:self.iv];
        self.anim.addBehavior(push)

        // ========
        
        let coll = UICollisionBehavior()
        coll.collisionMode = .Boundaries
        coll.collisionDelegate = self
        coll.addBoundaryWithIdentifier("floor",
            fromPoint:CGPointMake(0, self.view.bounds.height),
            toPoint:CGPointMake(self.view.bounds.width,
                self.view.bounds.height))
        self.anim.addBehavior(coll)
        coll.addItem(self.iv)
        
        // =========
        
        let bounce = UIDynamicItemBehavior()
        bounce.elasticity = 0.4
        self.anim.addBehavior(bounce)
        bounce.addItem(self.iv)

        

    }
    
}

extension ViewController : UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate {
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator!) {
        println("pause")
    }
    
    func dynamicAnimatorWillResume(animator: UIDynamicAnimator!) {
        println("resume")
    }
    
    func collisionBehavior(behavior: UICollisionBehavior!,
        beganContactForItem item: UIDynamicItem!,
        withBoundaryIdentifier identifier: NSCopying!,
        atPoint p: CGPoint) {
            println(p)
            // look for the dynamic item behavior
            for b in self.anim.behaviors as [UIDynamicBehavior] {
                if let bounce = b as? UIDynamicItemBehavior {
                    let v = bounce.angularVelocityForItem(self.iv)
                    println(v)
                    if (v <= 0.1) {
                        println("adding angular velocity")
                        bounce.addAngularVelocity(30, forItem:self.iv)
                    }
                    break;
                }
            }
    }

}
