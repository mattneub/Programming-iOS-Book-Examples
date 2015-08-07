

import UIKit


extension CGRect {
    var center : CGPoint {
    return CGPointMake(CGRectGetMidX(self), CGRectGetMidY(self))
    }
}

class CompassView : UIView {
    override class func layerClass() -> AnyClass {
        return CompassLayer.self
    }
    
    // view makes layer tappable
    @IBAction func tapped(t:UITapGestureRecognizer) {
        let p = t.locationOfTouch(0, inView: self.superview)
        let hitLayer = self.layer.hitTest(p)
        let arrow = (self.layer as! CompassLayer).arrow
        if hitLayer == arrow {
            arrow.transform = CATransform3DRotate(
                arrow.transform, CGFloat(M_PI)/4.0, 0, 0, 1)
        }
    }

}

class CompassLayer : CALayer {
    var arrow : CALayer!
    var rotationLayer : CALayer!
    var didSetup = false
    
    
    override func layoutSublayers() {
        if !self.didSetup {
            self.didSetup = true
            self.setup()
        }
    }
    
    // /*
    
    override func hitTest(p: CGPoint) -> CALayer? {
        var lay = super.hitTest(p)
        if lay == self.arrow {
            // artificially restrict touchability to roughly the shaft/point area
            let pt = self.arrow.convertPoint(p, fromLayer:self.superlayer)
            let path = CGPathCreateMutable()
            CGPathAddRect(path, nil, CGRectMake(10,20,20,80))
            CGPathMoveToPoint(path, nil, 0, 25)
            CGPathAddLineToPoint(path, nil, 20, 0)
            CGPathAddLineToPoint(path, nil, 40, 25)
            CGPathCloseSubpath(path)
            if !CGPathContainsPoint(path, nil, pt, false) {
                lay = nil;
            }
            let result = lay != nil ? "hit" : "missed"
            print("\(result) arrow at \(pt)")
        }
        return lay
    }

    // */
    
    func setup () {
        print("setup")
        
        
        // the gradient
        let g = CAGradientLayer()
        g.contentsScale = UIScreen.mainScreen().scale
        g.frame = self.bounds
        g.colors = [
            UIColor.blackColor().CGColor,
            UIColor.redColor().CGColor
            ]
        g.locations = [0.0,1.0]
        self.addSublayer(g) //

        // the circle
        let circle = CAShapeLayer()
        circle.contentsScale = UIScreen.mainScreen().scale
        circle.lineWidth = 2.0
        circle.fillColor = UIColor(red:0.9, green:0.95, blue:0.93, alpha:0.9).CGColor
        circle.strokeColor = UIColor.grayColor().CGColor
        let p = CGPathCreateMutable()
        CGPathAddEllipseInRect(p, nil, CGRectInset(self.bounds, 3, 3))
        circle.path = p
        self.addSublayer(circle) //
        circle.bounds = self.bounds
        circle.position = self.bounds.center
        
        // the four cardinal points
        let pts = "NESW"
        for (ix,c) in pts.characters.enumerate() {
            let t = CATextLayer()
            t.contentsScale = UIScreen.mainScreen().scale
            t.string = String(c)
            t.bounds = CGRectMake(0,0,40,40)
            t.position = circle.bounds.center
            let vert = circle.bounds.midY / t.bounds.height
            t.anchorPoint = CGPointMake(0.5, vert)
            // NSLog(@"%@", NSStringFromCGPoint(t.anchorPoint));
            t.alignmentMode = kCAAlignmentCenter
            t.foregroundColor = UIColor.blackColor().CGColor
            t.setAffineTransform(CGAffineTransformMakeRotation(CGFloat(ix)*CGFloat(M_PI)/2.0))
            circle.addSublayer(t)
        }

        
        // the arrow
        let arrow = CALayer()
        arrow.contentsScale = UIScreen.mainScreen().scale
        arrow.bounds = CGRectMake(0, 0, 40, 100)
        arrow.position = self.bounds.center
        arrow.anchorPoint = CGPointMake(0.5, 0.8)
        arrow.delegate = self // we will draw the arrow in the delegate method
        // in Swift, not a property:
        arrow.setAffineTransform(CGAffineTransformMakeRotation(CGFloat(M_PI)/5.0))
        self.addSublayer(arrow) //
        arrow.setNeedsDisplay() // draw, please
        
        self.arrow = arrow

    }
    
    override func drawLayer(layer: CALayer, inContext con: CGContext) {
        print("drawLayer:inContext: for arrow")
        
        // Questa poi la conosco pur troppo!
        
        // punch triangular hole in context clipping region
        CGContextMoveToPoint(con, 10, 100)
        CGContextAddLineToPoint(con, 20, 90)
        CGContextAddLineToPoint(con, 30, 100)
        CGContextClosePath(con)
        CGContextAddRect(con, CGContextGetClipBoundingBox(con))
        CGContextEOClip(con)
        
        // draw the vertical line, add its shape to the clipping region
        CGContextMoveToPoint(con, 20, 100)
        CGContextAddLineToPoint(con, 20, 19)
        CGContextSetLineWidth(con, 20)
        CGContextStrokePath(con)
        
        // draw the triangle, the point of the arrow
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(4,4), false, 0)
        let imcon = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(imcon, UIColor.redColor().CGColor)
        CGContextFillRect(imcon, CGRectMake(0,0,4,4))
        CGContextSetFillColorWithColor(imcon, UIColor.blueColor().CGColor)
        CGContextFillRect(imcon, CGRectMake(0,0,4,2))
        let stripes = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let stripesPattern = UIColor(patternImage:stripes)
        
        UIGraphicsPushContext(con)
        stripesPattern.setFill()
        let p = UIBezierPath()
        p.moveToPoint(CGPointMake(0,25))
        p.addLineToPoint(CGPointMake(20,0))
        p.addLineToPoint(CGPointMake(40,25))
        p.fill()
        UIGraphicsPopContext()

    }
    
    
}