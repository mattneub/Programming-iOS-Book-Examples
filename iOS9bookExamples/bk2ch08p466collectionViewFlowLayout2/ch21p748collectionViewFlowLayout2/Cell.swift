

import UIKit

class Cell : UICollectionViewCell {
    @IBOutlet var lab : UILabel!
    @IBOutlet var container : UIView!
    
    func capital(sender:AnyObject!) {
        // find my collection view
        var v : UIView = self
        repeat { v = v.superview! } while !(v is UICollectionView)
        let cv = v as! UICollectionView
        // ask it what index path we are
        let ip = cv.indexPathForCell(self)!
        // relay to its delegate
        cv.delegate?.collectionView?(cv, performAction:#selector(capital), forItemAtIndexPath: ip, withSender: sender)
    }
}

