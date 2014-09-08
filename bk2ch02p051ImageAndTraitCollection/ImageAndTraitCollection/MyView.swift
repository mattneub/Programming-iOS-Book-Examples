

import UIKit

class MyView: UIView {
    
    var image : UIImage!
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection) {
        if self.traitCollection != previousTraitCollection {
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        if self.image != nil {
            if let asset = self.image.imageAsset {
                let tc = self.traitCollection
                let im = asset.imageWithTraitCollection(tc)
                im.drawAtPoint(CGPointZero)
            }
        }
    }
}

