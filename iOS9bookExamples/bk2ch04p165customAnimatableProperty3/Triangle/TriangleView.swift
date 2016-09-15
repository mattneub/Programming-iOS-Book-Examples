

import UIKit

class TriangleView: UIView {
    
    var v1x : CGFloat {
        set {
            let lay = self.layer as! TriangleLayer
            lay.v1x = newValue
        }
        get {
            let lay = self.layer as! TriangleLayer
            return lay.v1x
        }
    }
    var v1y : CGFloat {
        set {
            let lay = self.layer as! TriangleLayer
            lay.v1y = newValue
        }
        get {
            let lay = self.layer as! TriangleLayer
            return lay.v1y
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        let lay = self.layer as! TriangleLayer
        lay.v1x = 0
        lay.v1y = 100
    }
    override class func layerClass() -> AnyClass {
        return TriangleLayer.self
    }
    override func drawRect(rect: CGRect) {}
}

class TriangleLayer : CALayer {
    
    @NSManaged var v1x : CGFloat
    @NSManaged var v1y : CGFloat
    
    override func drawInContext(ctx: CGContext) {
        CGContextMoveToPoint(ctx, 0, 0)
        CGContextAddLineToPoint(ctx, self.bounds.size.width, 0)
        CGContextAddLineToPoint(ctx, self.v1x, self.v1y)
        CGContextSetFillColorWithColor(ctx, UIColor.blueColor().CGColor)
        CGContextFillPath(ctx)
        // println(self)
        // interesting, self is actually a different presentation layer per frame
    }
        
    override class func needsDisplayForKey(key: String) -> Bool {
        if key == "v1x" || key == "v1y" {
            return true
        }
        return super.needsDisplayForKey(key)
    }
        
    override func actionForKey(key: String) -> CAAction? {
        if self.presentationLayer() != nil {
            if key == "v1x" || key == "v1y" {
                let ba = CABasicAnimation(keyPath: key)
                ba.fromValue = (self.presentationLayer() as! CALayer).valueForKey(key)
                return ba
            }
        }
        return super.actionForKey(key)
    }
}
