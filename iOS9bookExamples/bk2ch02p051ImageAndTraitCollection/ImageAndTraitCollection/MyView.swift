

import UIKit

class MyView: UIView {
    
    var image : UIImage!
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        self.setNeedsDisplay() // causes drawRect to be called
    }
    
    override func drawRect(rect: CGRect) {
        if var im = self.image {
            if let asset = self.image.imageAsset {
                let tc = self.traitCollection
                im = asset.imageWithTraitCollection(tc)
            }
            im.drawAtPoint(CGPointZero)
        }
    }
}

