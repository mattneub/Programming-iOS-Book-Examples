
import UIKit

class MyDropBounceAndRollBehavior : UIDynamicBehavior, UICollisionBehaviorDelegate {
    
    let v : UIView
    
    init(view v:UIView) {
        self.v = v
        super.init()
    }
    
    
    override func willMoveToAnimator(anim: UIDynamicAnimator?) {
        guard let anim = anim else { return }
        
        let sup = self.v.superview!
        
        let grav = UIGravityBehavior()
        grav.action = {
            // self will retain grav so do not let grav retain self
            // this is actually a simpler case for memory management,
            // because "self" incorporates all the behaviors at once
            [unowned self] in // * changed from weak to unowned here
            let items = anim.itemsInRect(sup.bounds) as! [UIView]
            if items.indexOf(self.v) == nil {
                anim.removeBehavior(self)
                self.v.removeFromSuperview()
                print("done")
            }
        }
        self.addChildBehavior(grav)
        grav.addItem(self.v)

        let push = UIPushBehavior(items:[self.v], mode:.Instantaneous)
        push.pushDirection = CGVectorMake(1, 0)
        //push.setTargetOffsetFromCenter(UIOffsetMake(0,-200), forItem: self.iv)
        self.addChildBehavior(push)

        let coll = UICollisionBehavior()
        coll.collisionMode = .Boundaries
        coll.collisionDelegate = self
        coll.addBoundaryWithIdentifier("floor",
            fromPoint:CGPointMake(0, sup.bounds.maxY),
            toPoint:CGPointMake(sup.bounds.maxX, sup.bounds.maxY))
        self.addChildBehavior(coll)
        coll.addItem(self.v)
        
        let bounce = UIDynamicItemBehavior()
        bounce.elasticity = 0.8
        self.addChildBehavior(bounce)
        bounce.addItem(self.v)

    }
    
    func collisionBehavior(behavior: UICollisionBehavior,
        beganContactForItem item: UIDynamicItem,
        withBoundaryIdentifier identifier: NSCopying?,
        atPoint p: CGPoint) {
            print(p)
            // look for the dynamic item behavior
            let b = self.childBehaviors
            if let ix = b.indexOf({$0 is UIDynamicItemBehavior}) {
                let bounce = b[ix] as! UIDynamicItemBehavior
                let v = bounce.angularVelocityForItem(item)
                print(v)
                if v <= 6 {
                    print("adding angular velocity")
                    bounce.addAngularVelocity(6, forItem:item)
                }
            }
    }
    
    deinit {
        print("farewell from behavior") // prove we are being deallocated in good order
    }
    
}
