

import UIKit

class MyView: UIView {
    
    var image : UIImage!
    
    override func traitCollectionDidChange(_: UITraitCollection?) {
        self.setNeedsDisplay() // causes draw(_:) to be called
    }
    
    override func draw(_ rect: CGRect) {
        if var im = self.image {
            if let asset = self.image.imageAsset {
                im = asset.image(with:self.traitCollection)
            }
            im.draw(at:.zero)
        }
    }
}

