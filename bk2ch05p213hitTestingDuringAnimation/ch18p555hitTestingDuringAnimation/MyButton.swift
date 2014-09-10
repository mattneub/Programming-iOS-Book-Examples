

import UIKit

class MyButton: UIButton {

    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let pres = self.layer.presentationLayer() as CALayer
        let suppt = self.convertPoint(point, toView: self.superview!)
        let prespt = self.superview!.layer.convertPoint(suppt, toLayer: pres)
        return super.hitTest(prespt, withEvent: event)
    }

}
