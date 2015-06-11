

import UIKit

class MyView: UIView {
    
    var image : UIImage!
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        if self.traitCollection != previousTraitCollection {
            self.setNeedsDisplay()
        }
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

