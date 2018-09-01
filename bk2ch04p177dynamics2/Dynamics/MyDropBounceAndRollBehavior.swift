
import UIKit

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}

extension UIDynamicAnimator {
    // work around absolutely unbelievable iOS 11 bug
    // we should be able to say let items = anim.items(in: sup.bounds) as! UIView
    // but a collision behavior has fallen into the array, so we crash if we say that
    // in fact, we can't even fetch items(in:) as a Swift array at all
    func views(in rect: CGRect) -> [UIView] {
        let nsitems = self.items(in: rect) as NSArray
        return nsitems.compactMap {$0 as? UIView}
    }
}

class MyDropBounceAndRollBehavior : UIDynamicBehavior, UICollisionBehaviorDelegate {
    
    let v : UIView
    
    init(view v:UIView) {
        self.v = v
        super.init()
    }
    
    
    override func willMove(to anim: UIDynamicAnimator?) {
        guard let anim = anim else { return }
        
        let sup = self.v.superview!
        let b = sup.bounds
        
        let grav = UIGravityBehavior()
        grav.action = { [unowned self] in
            // self will retain grav so do not let grav retain self
            // this is actually a simpler case for memory management,
            // because "self" incorporates all the behaviors at once
            // * changed from weak to unowned here
            
            // let items = anim.items(in: b) as! [UIView]
            // crash because it contains, wrongly, a collision behavior object
            let items = anim.views(in: b)
            if items.firstIndex(of:self.v) == nil {
                anim.removeBehavior(self)
                self.v.removeFromSuperview()
                print("done")
            }
            
        }
        self.addChildBehavior(grav)
        grav.addItem(self.v)

        let push = UIPushBehavior(items:[self.v], mode:.instantaneous)
        push.pushDirection = CGVector(1,0)
        //push.setTargetOffsetFromCenter(UIOffsetMake(0,-200), forItem: self.iv)
        self.addChildBehavior(push)

        let coll = UICollisionBehavior()
        coll.collisionMode = .boundaries
        coll.collisionDelegate = self
        coll.addBoundary(withIdentifier:"floor" as NSString,
                         from:CGPoint(b.minX, b.maxY),
                         to:CGPoint(b.maxX, b.maxY))
        self.addChildBehavior(coll)
        coll.addItem(self.v)
        
        let bounce = UIDynamicItemBehavior()
        bounce.elasticity = 0.8
        self.addChildBehavior(bounce)
        bounce.addItem(self.v)

    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior,
                                 beganContactFor item: UIDynamicItem,
                                 withBoundaryIdentifier identifier: NSCopying?,
                                 at p: CGPoint) {
            print(p)
            // look for the dynamic item behavior
            let b = self.childBehaviors
            if let bounce = (b.compactMap {$0 as? UIDynamicItemBehavior}).first {
                let v = bounce.angularVelocity(for:item)
                print(v)
                if v <= 6 {
                    print("adding angular velocity")
                    bounce.addAngularVelocity(6, for:item)
                }
            }
    }
    
    deinit {
        print("farewell from behavior") // prove we are being deallocated in good order
    }
    
}
