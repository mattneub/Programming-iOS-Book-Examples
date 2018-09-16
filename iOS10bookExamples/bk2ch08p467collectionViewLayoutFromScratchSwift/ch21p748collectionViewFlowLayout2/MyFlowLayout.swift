
import UIKit

class MyDynamicAnimator : UIDynamicAnimator {
    deinit {
        print("animator: farewell")
    }
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

class MyFlowLayout : UICollectionViewFlowLayout {
        
    var animating = false
    var animator : UIDynamicAnimator!
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //print("attsforelements2")
        //print("layout is \(self.collectionView!.collectionViewLayout)")
        var arr = super.layoutAttributesForElements(in: rect)!
        
        // in the book, omit this part and change var to let above
        // this part is just to get our left-justified layout
        if let sup = super.layoutAttributesForElements(in: rect) {
            arr = sup.map {
                atts in // remove (var atts)
                var atts = atts
                if atts.representedElementCategory == .cell {
                    let ip = atts.indexPath
                    atts = self.layoutAttributesForItem(at:ip)!
                }
                return atts
            }
        }
        
        // secret sauce for getting animation to work with a layout // *
        // for each attribute, if it can come from the animator, use that attribute instead
        if self.animating {
            return arr.map { atts in
                let path = atts.indexPath
                switch atts.representedElementCategory {
                case .cell:
                    if let atts2 = self.animator?
                        .layoutAttributesForCell(at: path) {
                            return atts2
                    }
                case .supplementaryView:
                    if let kind = atts.representedElementKind {
                        if let atts2 = self.animator?
                            .layoutAttributesForSupplementaryView(
                                ofKind: kind, at:path) {
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
        
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        //print("attsforitem2")
        //print("layout is \(self.collectionView!.collectionViewLayout)")

        var atts = super.layoutAttributesForItem(at: indexPath)!
        //print(atts.size)
        if indexPath.item == 0 {
            return atts // degenerate case 1
        }
        if atts.frame.origin.x - 1 <= self.sectionInset.left {
            return atts // degenerate case 2
        }
        let ipPv = IndexPath(item:indexPath.row-1, section:indexPath.section)
        let fPv = self.layoutAttributesForItem(at: ipPv)!.frame
        let rightPv = fPv.origin.x + fPv.size.width + self.minimumInteritemSpacing
        atts = atts.copy() as! UICollectionViewLayoutAttributes
        atts.frame.origin.x = rightPv
        return atts
    }
    
    func flush () {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let visworld = self.collectionView!.bounds
        let anim = MyDynamicAnimator(collectionViewLayout:self)
        self.animator = anim
        self.animating = true
        
        let atts = self.layoutAttributesForElements(in:visworld)!
        
        // collision behavior: floor, with a hole at the left end
        // we do not want the headers to be part of this collision behavior...
        // because they stretch all the way across the screen and won't fall through
        
        let items = atts.filter {
            $0.representedElementCategory == .cell
        }
        let coll = UICollisionBehavior(items:items)
        let p1 = CGPoint(visworld.minX + 80, visworld.maxY)
        let p2 = CGPoint(visworld.maxX, visworld.maxY)
        coll.addBoundary(withIdentifier: "bottom" as NSString, from:p1, to:p2)
        coll.collisionMode = .boundaries
        coll.collisionDelegate = self
        anim.addBehavior(coll)

        let beh = UIDynamicItemBehavior(items:atts)
        beh.elasticity = 0.8
        beh.friction = 0.1
        anim.addBehavior(beh)
        
        let grav = UIGravityBehavior(items:atts)
        grav.magnitude = 0.8
        grav.action = {
            let atts = self.animator.items(in:visworld)
            if atts.count == 0 || anim.elapsedTime > 4 {
                //print("done")
                delay(0) { // memory management
                    self.animator.removeAllBehaviors()
                    self.animator = nil
                }
                delay(0.4) { // looks better if there's a pause
                    self.animating = false
                    self.invalidateLayout()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
        anim.addBehavior(grav)
    }
    
}

extension MyFlowLayout : UICollisionBehaviorDelegate {
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
    
        let push = UIPushBehavior(items:[item], mode:.continuous)
        push.setAngle(3 * .pi/4.0, magnitude:1.5)
        self.animator.addBehavior(push)
    }

}
