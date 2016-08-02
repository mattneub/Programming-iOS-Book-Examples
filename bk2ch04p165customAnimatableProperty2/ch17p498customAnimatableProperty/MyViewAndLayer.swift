

import UIKit


class MyView : UIView { // exists purely to host MyLayer
    override class var layerClass : AnyClass {
        return MyLayer.self
    }
    override func draw(_ rect: CGRect) {} // so that layer will draw itself
}

// see also Nick Lockwood's discussion http://www.objc.io/issue-12/animating-custom-layer-properties.html

/*
// copied from Apple's example, but I don't see how it helps in this situation

-(id)initWithLayer:(id)layer {
self = [super initWithLayer:layer];
if ([layer isKindOfClass:[MyLayer class]])
self.thickness = ((MyLayer*)layer).thickness;
return self;
}
*/

class MyLayer : CALayer {
    // new in Swift 2.0, @NSManaged acts as Objective-C @dynamic
    // we don't need any Objective-C for this example any more!
    @NSManaged var thickness : CGFloat
    
    // this Swift extension contains everything except the @dynamic declaration...
    // ...which can only be made in Objective-C
    
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
    
    // this plus the "dynamic" declaration is what what permits *implicit* animation
    // NB that we can implicitly animate even for view's underlying layer!
    // this is something the book has always been wrong about
    
    override func action(forKey key: String) -> CAAction? {
        if key == #keyPath(thickness) {
            let ba = CABasicAnimation(keyPath: key)
            // stolen directly from Apple's sample code:
            // sorry, guys, but I would never have thought of this!
            ba.fromValue = self.presentation()!.value(forKey:key)
            return ba
        }
        return super.action(forKey:key)
    }
}
