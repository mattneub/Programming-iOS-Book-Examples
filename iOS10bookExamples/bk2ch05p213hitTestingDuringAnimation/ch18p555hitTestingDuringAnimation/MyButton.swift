

import UIKit

class MyButton: UIButton {

    override func hitTest(_ point: CGPoint, with e: UIEvent?) -> UIView? {
        let pres = self.layer.presentation()!
        let suppt = self.convert(point, to: self.superview!)
        let prespt = self.superview!.layer.convert(suppt, to: pres)
        return super.hitTest(prespt, with: e)
    }

}
