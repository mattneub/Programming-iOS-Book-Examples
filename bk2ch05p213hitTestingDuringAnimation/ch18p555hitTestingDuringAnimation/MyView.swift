

import UIKit
import QuartzCore

class MyView : UIView {
    @IBOutlet var v : UIView! // the animated subview
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let t = UITapGestureRecognizer(target: self, action: "tap:")
        self.v.addGestureRecognizer(t)
        t.cancelsTouchesInView = false
        // uncomment next line to see how button, even if tappable, "swallows the touch" while animating
        // self.v.removeGestureRecognizer(t)
    }
    
    func tap(g:UIGestureRecognizer!) {
        println("tap! (gesture recognizer)")
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView! {
        // uncomment this next line to see what it's like without our munged hit-testing
        // return super.hitTest(point, withEvent: event)
        // v is the animated subview
        if let lay = self.v.layer.presentationLayer() as? CALayer {
            if let hitLayer = lay.hitTest(point) {
                if (hitLayer == lay || hitLayer.superlayer == lay) {
                    return self.v
                }
            }
        }
        let hitView = super.hitTest(point, withEvent:event)
        if (hitView == self.v) {
            return self
        }
        return hitView
    }
    
}
