

import UIKit
import QuartzCore

class MyView: UIView, Printable {
    
    @IBInspectable var name : String?
    // new Xcode 6 feature, edit properties in Attributes inspector instead of Runtime Attributes

    override var description : String {
        return super.description + "\n" + self.name!
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        println("\(self) \(__FUNCTION__)")
    }
    
//    override func layoutSublayersOfLayer(layer: CALayer!) {
//        super.layoutSublayersOfLayer(layer)
//        println("\(self) \(__FUNCTION__)")
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        println("\(self) \(__FUNCTION__)")
    }
}
