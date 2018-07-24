

import UIKit

class Cell : UICollectionViewCell {
    @IBOutlet var lab : UILabel!
    
    @objc func capital(_ sender: Any!) {
        // find my collection view
        var v : UIView = self
        repeat { v = v.superview! } while !(v is UICollectionView)
        let cv = v as! UICollectionView
        // ask it what index path we are
        let ip = cv.indexPath(for: self)!
        // relay to its delegate
        cv.delegate?.collectionView?(cv, performAction:#selector(capital), forItemAt: ip, withSender: sender)
    }
    
    /*
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sz = self.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        sz.width = ceil(sz.width); sz.height = ceil(sz.height)
        return sz
    }
 */
    
    /*
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        var sz = self.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        sz.width = ceil(sz.width); sz.height = ceil(sz.height)
        let atts = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
        atts.size = sz
        return atts
    }
 */

}

