
import UIKit

class MyFlowLayout : UICollectionViewFlowLayout {
    // how to left-justify every "line" of the layout
    // looks much nicer, in my humble opinion
    
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let arr = super.layoutAttributesForElementsInRect(rect)!
        return arr.map {
            (var atts) in
            if atts.representedElementKind == nil {
                let ip = atts.indexPath
                atts = self.layoutAttributesForItemAtIndexPath(ip)!
            }
            return atts
        }
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

}
