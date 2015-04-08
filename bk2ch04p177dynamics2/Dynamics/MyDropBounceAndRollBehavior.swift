
import UIKit

class MyDropBounceAndRollBehavior : UIDynamicBehavior, UICollisionBehaviorDelegate {
    
    let v : UIView
    
    init(view v:UIView) {
        self.v = v
        super.init()
    }
    
    // exclamation mark instead of question mark is deliberate so I don't have to keep unwrapping!
    
    override func willMoveToAnimator(anim: UIDynamicAnimator!) {
        if anim == nil { return }
        
        let sup = self.v.superview!
        
        let grav = UIGravityBehavior()
        grav.action = {
            // self will retain grav so do not let grav retain self
            // this is actually a simpler case for memory management,
            // because "self" incorporates all the behaviors at once
            [unowned self] in // * changed from weak to unowned here
            let items = anim.itemsInRect(sup.bounds) as! [UIView]
            if find(items, self.v) == nil {
                anim.removeBehavior(self)
                self.v.removeFromSuperview()
                println("done")
            }
        }
        self.addChildBehavior(grav)
        grav.addItem(self.v)

        let push = UIPushBehavior(items:[self.v], mode:.Instantaneous)
        push.pushDirection = CGVectorMake(2, 0)
        // push.setTargetOffsetFromCenter(UIOffsetMake(0, -200), forItem:self.v)
        self.addChildBehavior(push)

        let coll = UICollisionBehavior()
        coll.collisionMode = .Boundaries
        coll.collisionDelegate = self
        coll.addBoundaryWithIdentifier("floor",
            fromPoint:CGPointMake(0, sup.bounds.size.height),
            toPoint:CGPointMake(sup.bounds.size.width,
                sup.bounds.size.height))
        self.addChildBehavior(coll)
        coll.addItem(self.v)
        
        let bounce = UIDynamicItemBehavior()
        bounce.elasticity = 0.4
        self.addChildBehavior(bounce)
        bounce.addItem(self.v)

    }
    
    func collisionBehavior(behavior: UICollisionBehavior,
        beganContactForItem item: UIDynamicItem,
        withBoundaryIdentifier identifier: NSCopying,
        atPoint p: CGPoint) {
            println(p)
            // look for the dynamic item behavior
            for b in self.childBehaviors as! [UIDynamicBehavior] {
                if let bounce = b as? UIDynamicItemBehavior {
                    let v = bounce.angularVelocityForItem(item)
                    println(v)
                    if v <= 0.1 {
                        println("adding angular velocity")
                        bounce.addAngularVelocity(30, forItem:item)
                    }
                    break;
                }
            }
    }
    
    deinit {
        println("farewell from behavior") // prove we are being deallocated in good order
    }
    
}
