
import UIKit

class MyDynamicAnimator : UIDynamicAnimator {
    deinit {
        print("animator: farewell")
    }
}

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class MyFlowLayout : UICollectionViewFlowLayout {
    
    var animating = false
    var animator : UIDynamicAnimator!
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var arr = super.layoutAttributesForElementsInRect(rect)!
        if let sup = super.layoutAttributesForElementsInRect(rect) {
            arr = sup.map {
                (var atts) in
                if atts.representedElementKind == nil {
                    let ip = atts.indexPath
                    atts = self.layoutAttributesForItemAtIndexPath(ip)!
                }
                return atts
            }
        }
        
        // secret sauce for getting animation to work with a layout // *
        // for each attribute, if it can come from the animator, use that attribute instead
        if self.animating {
            return arr.map {
                atts in
                let path = atts.indexPath
                switch atts.representedElementCategory {
                case .Cell:
                    if let atts2 = self.animator?
                        .layoutAttributesForCellAtIndexPath(path) {
                            return atts2
                    }
                case .SupplementaryView:
                    if let kind = atts.representedElementKind {
                        if let atts2 = self.animator?
                            .layoutAttributesForSupplementaryViewOfKind(
                                kind, atIndexPath:path) {
                                    return atts2
                        }
                    }
                default: break
                }
                return atts
            }
        }
        return arr
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var atts = super.layoutAttributesForItemAtIndexPath(indexPath)!
        if indexPath.item == 0 {
            return atts // degenerate case 1
        }
        if atts.frame.origin.x - 1 <= self.sectionInset.left {
            return atts // degenerate case 2
        }
        let ipPv = NSIndexPath(forItem:indexPath.item-1, inSection:indexPath.section)
        let fPv = self.layoutAttributesForItemAtIndexPath(ipPv)!.frame
        let rightPv = fPv.origin.x + fPv.size.width + self.minimumInteritemSpacing
        atts = atts.copy() as! UICollectionViewLayoutAttributes
        atts.frame.origin.x = rightPv
        return atts
    }
    
    func flush () {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let visworld = self.collectionView!.bounds
        let anim = MyDynamicAnimator(collectionViewLayout:self)
        self.animator = anim
        
        let atts = self.layoutAttributesForElementsInRect(visworld)!
        self.animating = true
        
        // collision behavior: floor, with a hole at the left end
        // we do not want the headers to be part of this collision behavior...
        // because they stretch all the way across the screen and won't fall through
        
        let items = atts.filter {
            $0.representedElementKind == nil
        }
        let coll = UICollisionBehavior(items:items)
        let p1 = CGPointMake(visworld.minX + 80, visworld.maxY)
        let p2 = CGPointMake(visworld.maxX, visworld.maxY)
        coll.addBoundaryWithIdentifier("bottom", fromPoint:p1, toPoint:p2)
        coll.collisionMode = .Boundaries
        coll.collisionDelegate = self
        anim.addBehavior(coll)

        let beh = UIDynamicItemBehavior(items:atts)
        beh.elasticity = 0.8
        beh.friction = 0.1
        anim.addBehavior(beh)
        
        let grav = UIGravityBehavior(items:atts)
        grav.magnitude = 0.8
        grav.action = {
            let atts = self.animator.itemsInRect(visworld)
            if atts.count == 0 || anim.elapsedTime() > 4 {
                print("done")
                delay(0) { // memory management
                    self.animator.removeAllBehaviors()
                    self.animator = nil
                }
                delay(0.4) { // looks better if there's a pause
                    self.animating = false
                    self.invalidateLayout()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                }
            }
        }
        anim.addBehavior(grav)
    }
}

extension MyFlowLayout : UICollisionBehaviorDelegate {
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
    
        let push = UIPushBehavior(items:[item], mode:.Continuous)
        push.setAngle(3*CGFloat(M_PI)/4.0, magnitude:1.5)
        self.animator.addBehavior(push)
    }

}
