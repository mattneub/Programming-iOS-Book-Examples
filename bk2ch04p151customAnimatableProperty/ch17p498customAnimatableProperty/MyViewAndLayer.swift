

import UIKit


class MyView : UIView { // exists purely to host MyLayer
    override class func layerClass() -> AnyClass {
        return MyLayer.self
    }
    override func drawRect(rect: CGRect) {} // so that layer will draw itself
}

class MyLayer : CALayer {
    
    var thickness : CGFloat = 0
    
    override class func needsDisplayForKey(key: String) -> Bool {
        if key == "thickness" {
            return true
        }
        return super.needsDisplayForKey(key)
    }
    
    override func drawInContext(con: CGContext) {
        let r = self.bounds.insetBy(dx:20, dy:20)
        CGContextSetFillColorWithColor(con, UIColor.redColor().CGColor)
        CGContextFillRect(con, r)
        CGContextSetLineWidth(con, self.thickness)
        CGContextStrokeRect(con, r)
    }
    
}