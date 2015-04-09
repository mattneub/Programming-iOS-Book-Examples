

import UIKit


class MyView : UIView { // exists purely to host MyLayer
    override class func layerClass() -> AnyClass {
        return MyLayer.self
    }
    override func drawRect(rect: CGRect) {} // so that layer will draw itself
}

// see also Nick Lockwood's discussion http://www.objc.io/issue-12/animating-custom-layer-properties.html

public extension MyLayer {
    
    // this Swift extension contains everything except the @dynamic declaration...
    // ...which can only be made in Objective-C
    
    override class func needsDisplayForKey(key: String!) -> Bool {
        if key == "thickness" {
            return true
        }
        return super.needsDisplayForKey(key)
    }
    
    override func drawInContext(con: CGContext) {
        let r = self.bounds.rectByInsetting(dx:20, dy:20)
        CGContextSetFillColorWithColor(con, UIColor.redColor().CGColor)
        CGContextFillRect(con, r)
        CGContextSetLineWidth(con, self.thickness)
        CGContextStrokeRect(con, r)
    }
    
    // this plus the "dynamic" declaration is what what permits *implicit* animation
    // NB that we can implicitly animate even for view's underlying layer!
    // this is something the book has always been wrong about
    
    override func actionForKey(key: String!) -> CAAction! {
        if key == "thickness" {
            let ba = CABasicAnimation(keyPath: key)
            // stolen directly from Apple's sample code:
            // sorry, guys, but I would never have thought of this!
            ba.fromValue = (self.presentationLayer() as! CALayer).valueForKey(key)
            return ba
        }
        return super.actionForKey(key)
    }
}