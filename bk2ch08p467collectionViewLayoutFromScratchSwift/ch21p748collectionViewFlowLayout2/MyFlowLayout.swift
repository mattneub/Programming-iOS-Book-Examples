
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

/*
Lots of changes here, some of them rather half-baked perhaps.
We got a helpful warning that we are not supposed to be modifying attributes without copying,
so now I copy everywhere.
Lots of things turned into optionals and I may not be dealing coherently with them.
*/

/*
If we run, we now run without crashing on Flush,
but we sometimes crash with a dangling pointer on Push
and I have not tracked this down yet
*/

class MyFlowLayout : UICollectionViewFlowLayout {
    
    var animating = false
    var animator : UIDynamicAnimator!
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var arr : [UICollectionViewLayoutAttributes]? = nil
        if let sup = super.layoutAttributesForElementsInRect(rect) {
            arr = sup.map {
                atts -> UICollectionViewLayoutAttributes in
                let attscopy = atts.copy() as! UICollectionViewLayoutAttributes
                if attscopy.representedElementKind == nil {
                    let ip = atts.indexPath
                    if let frame = self.layoutAttributesForItemAtIndexPath(ip)?.frame {
                        attscopy.frame = frame
                    }
                }
                return attscopy
            }
        }
        
        // secret sauce for getting animation to work with a layout
        if let arr = arr where self.animating {
            var marr = [UICollectionViewLayoutAttributes]()
            for atts in arr {
                let path = atts.indexPath
                var atts2 : UICollectionViewLayoutAttributes? = nil
                switch atts.representedElementCategory {
                case .Cell:
                    atts2 = self.animator?.layoutAttributesForCellAtIndexPath(path)
                case .SupplementaryView:
                    if let kind = atts.representedElementKind {
                        atts2 = self.animator?.layoutAttributesForSupplementaryViewOfKind(kind, atIndexPath:path)
                    }
                default: break
                }
                marr += [atts2 ?? atts]
            }
            return marr
        }
        return arr
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var atts = super.layoutAttributesForItemAtIndexPath(indexPath)
        if atts != nil {
            if indexPath.item == 0 {
                return atts // degenerate case 1
            }
            if atts!.frame.origin.x - 1 <= self.sectionInset.left {
                return atts // degenerate case 2
            }
            let ipPrev = NSIndexPath(forItem:indexPath.item-1, inSection:indexPath.section)
            if let fPrev = self.layoutAttributesForItemAtIndexPath(ipPrev)?.frame {
                let rightPrev = fPrev.origin.x + fPrev.size.width + self.minimumInteritemSpacing
                let attsCopy = atts!.copy() as! UICollectionViewLayoutAttributes
                attsCopy.frame.origin.x = rightPrev
                atts = attsCopy
            }
        }
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
