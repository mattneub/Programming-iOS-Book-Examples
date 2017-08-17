

import UIKit


class MyView : UIView { // exists purely to host MyLayer
    override class var layerClass : AnyClass {
        return MyLayer.self
    }
    override func draw(_ rect: CGRect) {} // so that layer will draw itself
}

class MyLayer : CALayer {
    
    @objc var thickness : CGFloat = 0
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == #keyPath(thickness) {
            return true
        }
        return super.needsDisplay(forKey:key)
    }
    
    override func draw(in con: CGContext) {
        let r = self.bounds.insetBy(dx:20, dy:20)
        con.setFillColor(UIColor.red.cgColor)
        con.fill(r)
        con.setLineWidth(self.thickness)
        con.stroke(r)
    }
    
}
