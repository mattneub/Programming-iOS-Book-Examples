
import UIKit

class MyView : UIView {
    
    init() {
        super.init(frame:CGRectZero)
        self.opaque = false
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.opaque = false
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.opaque = false
    }
    
    override func drawRect(rect: CGRect) {
        let which = 1
        switch which {
        case 1:
            let con = UIGraphicsGetCurrentContext()
            
            // draw a black (by default) vertical line, the shaft of the arrow
            CGContextMoveToPoint(con, 100, 100)
            CGContextAddLineToPoint(con, 100, 19)
            CGContextSetLineWidth(con, 20)
            CGContextStrokePath(con)
            
            // draw a red triangle, the point of the arrow
            CGContextSetFillColorWithColor(con, UIColor.redColor().CGColor)
            CGContextMoveToPoint(con, 80, 25)
            CGContextAddLineToPoint(con, 100, 0)
            CGContextAddLineToPoint(con, 120, 25)
            CGContextFillPath(con)
            
            // snip a triangle out of the shaft by drawing in Clear blend mode
            CGContextMoveToPoint(con, 90, 101)
            CGContextAddLineToPoint(con, 100, 90)
            CGContextAddLineToPoint(con, 110, 101)
            CGContextSetBlendMode(con, kCGBlendModeClear)
            CGContextFillPath(con)
            
        case 2:
            let p = UIBezierPath()
            p.moveToPoint(CGPointMake(100,100))
            p.addLineToPoint(CGPointMake(100, 19))
            p.lineWidth = 20
            p.stroke()
            
            UIColor.redColor().set()
            p.removeAllPoints()
            p.moveToPoint(CGPointMake(80,25))
            p.addLineToPoint(CGPointMake(100, 0))
            p.addLineToPoint(CGPointMake(120, 25))
            p.fill()
            
            p.removeAllPoints()
            p.moveToPoint(CGPointMake(90,101))
            p.addLineToPoint(CGPointMake(100, 90))
            p.addLineToPoint(CGPointMake(110, 101))
            p.fillWithBlendMode(kCGBlendModeClear, alpha:1.0)
            
        case 3:
            
            // obtain the current graphics context
            let con = UIGraphicsGetCurrentContext()
            
            // punch triangular hole in context clipping region
            CGContextMoveToPoint(con, 90, 100)
            CGContextAddLineToPoint(con, 100, 90)
            CGContextAddLineToPoint(con, 110, 100)
            CGContextClosePath(con)
            CGContextAddRect(con, CGContextGetClipBoundingBox(con))
            CGContextEOClip(con)
            
            // draw the vertical line
            CGContextMoveToPoint(con, 100, 100)
            CGContextAddLineToPoint(con, 100, 19)
            CGContextSetLineWidth(con, 20)
            CGContextStrokePath(con)
            
            // draw the red triangle, the point of the arrow
            CGContextSetFillColorWithColor(con, UIColor.redColor().CGColor)
            CGContextMoveToPoint(con, 80, 25)
            CGContextAddLineToPoint(con, 100, 0)
            CGContextAddLineToPoint(con, 120, 25)
            CGContextFillPath(con)
            
        case 4:
            // obtain the current graphics context
            let con = UIGraphicsGetCurrentContext()
            CGContextSaveGState(con)
            
            // punch triangular hole in context clipping region
            CGContextMoveToPoint(con, 90, 100)
            CGContextAddLineToPoint(con, 100, 90)
            CGContextAddLineToPoint(con, 110, 100)
            CGContextClosePath(con)
            CGContextAddRect(con, CGContextGetClipBoundingBox(con))
            CGContextEOClip(con)
            
            // draw the vertical line, add its shape to the clipping region
            CGContextMoveToPoint(con, 100, 100)
            CGContextAddLineToPoint(con, 100, 19)
            CGContextSetLineWidth(con, 20)
            CGContextReplacePathWithStrokedPath(con)
            CGContextClip(con)
            
            // draw the gradient
            let locs : [CGFloat] = [ 0.0, 0.5, 1.0 ]
            let colors : [CGFloat] = [
                0.3,0.3,0.3,0.8, // starting color, transparent gray
                0.0,0.0,0.0,1.0, // intermediate color, black
                0.3,0.3,0.3,0.8 // ending color, transparent gray
            ]
            let sp = CGColorSpaceCreateDeviceGray()
            let grad =
                CGGradientCreateWithColorComponents (sp, colors, locs, 3)
            CGContextDrawLinearGradient (
                con, grad, CGPointMake(89,0), CGPointMake(111,0), 0)
            
            CGContextRestoreGState(con) // done clipping
            
            // draw the red triangle, the point of the arrow
            CGContextSetFillColorWithColor(con, UIColor.redColor().CGColor)
            CGContextMoveToPoint(con, 80, 25)
            CGContextAddLineToPoint(con, 100, 0)
            CGContextAddLineToPoint(con, 120, 25)
            CGContextFillPath(con)
            
        case 5:
            // obtain the current graphics context
            let con = UIGraphicsGetCurrentContext()
            CGContextSaveGState(con)
            
            // punch triangular hole in context clipping region
            CGContextMoveToPoint(con, 90, 100)
            CGContextAddLineToPoint(con, 100, 90)
            CGContextAddLineToPoint(con, 110, 100)
            CGContextClosePath(con)
            CGContextAddRect(con, CGContextGetClipBoundingBox(con))
            CGContextEOClip(con)
            
            // draw the vertical line, add its shape to the clipping region
            CGContextMoveToPoint(con, 100, 100)
            CGContextAddLineToPoint(con, 100, 19)
            CGContextSetLineWidth(con, 20)
            CGContextReplacePathWithStrokedPath(con)
            CGContextClip(con)
            
            // draw the gradient
            let locs : [CGFloat] = [ 0.0, 0.5, 1.0 ]
            let colors : [CGFloat] = [
                0.3,0.3,0.3,0.8, // starting color, transparent gray
                0.0,0.0,0.0,1.0, // intermediate color, black
                0.3,0.3,0.3,0.8 // ending color, transparent gray
            ]
            let sp = CGColorSpaceCreateDeviceGray()
            let grad =
            CGGradientCreateWithColorComponents (sp, colors, locs, 3)
            CGContextDrawLinearGradient (
                con, grad, CGPointMake(89,0), CGPointMake(111,0), 0)
            
            CGContextRestoreGState(con) // done clipping
            
            // draw the red triangle, the point of the arrow
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(4,4), false, 0)
            let imcon = UIGraphicsGetCurrentContext()
            CGContextSetFillColorWithColor(imcon, UIColor.redColor().CGColor)
            CGContextFillRect(imcon, CGRectMake(0,0,4,4))
            CGContextSetFillColorWithColor(imcon, UIColor.blueColor().CGColor)
            CGContextFillRect(imcon, CGRectMake(0,0,4,2))
            let stripes = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let stripesPattern = UIColor(patternImage:stripes)
            stripesPattern.setFill()
            let p = UIBezierPath()
            p.moveToPoint(CGPointMake(80,25))
            p.addLineToPoint(CGPointMake(100,0))
            p.addLineToPoint(CGPointMake(120,25))
            p.fill()
            
        case 6:
            
            // obtain the current graphics context
            let con = UIGraphicsGetCurrentContext()
            CGContextSaveGState(con)
            
            // punch triangular hole in context clipping region
            CGContextMoveToPoint(con, 90, 100)
            CGContextAddLineToPoint(con, 100, 90)
            CGContextAddLineToPoint(con, 110, 100)
            CGContextClosePath(con)
            CGContextAddRect(con, CGContextGetClipBoundingBox(con))
            CGContextEOClip(con)
            
            // draw the vertical line, add its shape to the clipping region
            CGContextMoveToPoint(con, 100, 100)
            CGContextAddLineToPoint(con, 100, 19)
            CGContextSetLineWidth(con, 20)
            CGContextReplacePathWithStrokedPath(con)
            CGContextClip(con)
            
            // draw the gradient
            let locs : [CGFloat] = [ 0.0, 0.5, 1.0 ]
            let colors : [CGFloat] = [
                0.3,0.3,0.3,0.8, // starting color, transparent gray
                0.0,0.0,0.0,1.0, // intermediate color, black
                0.3,0.3,0.3,0.8 // ending color, transparent gray
            ]
            let sp = CGColorSpaceCreateDeviceGray()
            let grad =
            CGGradientCreateWithColorComponents (sp, colors, locs, 3)
            CGContextDrawLinearGradient (
                con, grad, CGPointMake(89,0), CGPointMake(111,0), 0)
            
            CGContextRestoreGState(con) // done clipping
            
            // draw the red triangle, the point of the arrow
            let sp2 = CGColorSpaceCreatePattern(nil)
            CGContextSetFillColorSpace(con, sp2)
            // can't construct CGPatternRef in Swift
            // (because we can't form the pointer-to-C-function)
            // so we construct it in Objective-C and pass it
            let patt = PatternHelper().patternMaker().takeRetainedValue()
            var alph : CGFloat = 1.0
            CGContextSetFillPattern(con, patt, &alph)
            
            CGContextMoveToPoint(con, 80, 25)
            CGContextAddLineToPoint(con, 100, 0)
            CGContextAddLineToPoint(con, 120, 25)
            CGContextFillPath(con)
            
            
        default: break
        }
    }
    
}
