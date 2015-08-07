

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
    var rotationLayer : CALayer!
    var didSetup = false
    
    let which = 2

    func doRotate () {
        print("rotate")
        switch which {
        case 1:
            self.rotationLayer.anchorPoint = CGPointMake(1,0.5)
            self.rotationLayer.position = CGPointMake(self.bounds.maxX, self.bounds.midY)
            self.rotationLayer.transform = CATransform3DMakeRotation(CGFloat(M_PI)/4.0, 0, 1, 0)
//             self.rotationLayer.setValue(M_PI/4, forKeyPath:"transform.rotation.y")
//             self.rotationLayer.transform.rotation.y = M_PI/4 // nope, sorry
        case 2:
            self.rotationLayer.anchorPoint = CGPointMake(1,0.5)
            self.rotationLayer.position = CGPointMake(self.bounds.maxX, self.bounds.midY)
            self.rotationLayer.transform = CATransform3DMakeRotation(CGFloat(M_PI)/4.0, 0, 1, 0)
            
            var transform = CATransform3DIdentity
            transform.m34 = -1.0/1000.0
            self.sublayerTransform = transform

        default: break
        }
    }
    
    override func layoutSublayers() {
        if !self.didSetup {
            self.didSetup = true
            self.setup()
            delay(1) {self.doRotate()}
        }
    }
    
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
        g.addSublayer(circle) //
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
        g.addSublayer(arrow) //
        arrow.setNeedsDisplay() // draw, please
        
        // self.arrow = arrow
        self.rotationLayer = g

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