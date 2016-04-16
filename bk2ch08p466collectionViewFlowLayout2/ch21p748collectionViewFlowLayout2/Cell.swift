

import UIKit

class Cell : UICollectionViewCell {
    @IBOutlet var lab : UILabel!
    @IBOutlet var container : UIView!
    
    func capital(_ sender:AnyObject!) {
        // find my collection view
        var v : UIView = self
        repeat { v = v.superview! } while !(v is UICollectionView)
        let cv = v as! UICollectionView
        // ask it what index path we are
        let ip = cv.indexPath(for: self)!
        // relay to its delegate
        cv.delegate?.collectionView?(cv, performAction:#selector(capital), forItemAt: ip, withSender: sender)
    }
}

