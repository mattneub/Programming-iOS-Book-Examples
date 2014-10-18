

import UIKit


func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

extension CGRect {
    var center : CGPoint {
    return CGPointMake(CGRectGetMidX(self), CGRectGetMidY(self))
    }
}

// view exists solely to host layer
class CompassView : UIView {
    override class func layerClass() -> AnyClass {
        return CompassLayer.self
    }
}

class CompassLayer : CALayer {
    var arrow : CALayer?
    var didSetup = false
    
    override func layoutSublayers() {
        if !self.didSetup {
            self.didSetup = true
            self.setup()
        }
    }
    
    func setup () {
        println("setup")
        
        // the gradient
        let g = CAGradientLayer()
        g.contentsScale = UIScreen.mainScreen().scale
        g.frame = self.bounds
        g.colors = [
            UIColor.blackColor().CGColor as AnyObject,
            UIColor.redColor().CGColor as AnyObject
            ]
        g.locations = [0.0,1.0]
        self.addSublayer(g)

        // the circle
        let circle = CAShapeLayer()
        circle.contentsScale = UIScreen.mainScreen().scale
        circle.lineWidth = 2.0
        circle.fillColor = UIColor(red:0.9, green:0.95, blue:0.93, alpha:0.9).CGColor
        circle.strokeColor = UIColor.grayColor().CGColor
        let p = CGPathCreateMutable()
        CGPathAddEllipseInRect(p, nil, CGRectInset(self.bounds, 3, 3))
        circle.path = p
        self.addSublayer(circle)
        circle.bounds = self.bounds
        circle.position = self.bounds.center
        
        // the four cardinal points
        let pts = "NESW"
        for (ix,c) in enumerate(pts) {
            let t = CATextLayer()
            t.contentsScale = UIScreen.mainScreen().scale
            t.string = String(c)
            t.bounds = CGRectMake(0,0,40,40)
            t.position = circle.bounds.center
            let vert = circle.bounds.midY / t.bounds.height
            t.anchorPoint = CGPointMake(0.5, vert)
            // println(t.anchorPoint)
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
        self.addSublayer(arrow)
        arrow.setNeedsDisplay() // draw, please
        
        // uncomment next line (only) for contentsCenter and contentsGravity
        // delay (0.4) {self.resizeArrowLayer(arrow)}

        // uncomment next line (only) for layer mask
        // self.mask(arrow)

        
        self.arrow = arrow

    }
    
    override func drawLayer(layer: CALayer, inContext con: CGContext) {
        println("drawLayer:inContext: for arrow")
        
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
        let imcon = UIGraphicsGetCurrentContext()
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
    
    func resizeArrowLayer(arrow:CALayer) {
        println("resize arrow")
        arrow.needsDisplayOnBoundsChange = false
        arrow.contentsCenter = CGRectMake(0.0, 0.4, 1.0, 0.6)
        arrow.contentsGravity = kCAGravityResizeAspect
        arrow.bounds.inset(dx: -20, dy: -20)
    }
    
    func mask(arrow:CALayer) {
        let mask = CAShapeLayer()
        mask.frame = arrow.bounds
        let p2 = CGPathCreateMutable()
        CGPathAddEllipseInRect(p2, nil, CGRectInset(mask.bounds, 10, 10))
        mask.strokeColor = UIColor(white:0.0, alpha:0.5).CGColor
        mask.lineWidth = 20
        mask.path = p2
        arrow.mask = mask
    }
    
}