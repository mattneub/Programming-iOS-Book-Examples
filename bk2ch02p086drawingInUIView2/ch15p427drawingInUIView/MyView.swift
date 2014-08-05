
import UIKit

class MyView : UIView {
    
    lazy var arrow : UIImage = self.arrowImage()
    
    override init (frame:CGRect) {
        super.init(frame:frame)
        self.opaque = false
    }

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    func arrowImage () -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(40,100), false, 0.0)
        
        // obtain the current graphics context
        let con = UIGraphicsGetCurrentContext()
        CGContextSaveGState(con)
        
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
            con, grad, CGPointMake(9,0), CGPointMake(31,0), 0)
        
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
        p.moveToPoint(CGPointMake(0,25))
        p.addLineToPoint(CGPointMake(20,0))
        p.addLineToPoint(CGPointMake(40,25))
        p.fill()
        
        let im = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return im

    }
    
    override func drawRect(rect: CGRect) {

        let which = 1
        switch which {
        case 1:
            let con = UIGraphicsGetCurrentContext()
            self.arrow.drawAtPoint(CGPointMake(0,0))
            for _ in 0..<3 {
                CGContextTranslateCTM(con, 20, 100)
                CGContextRotateCTM(con, 30 * CGFloat(M_PI)/180.0)
                CGContextTranslateCTM(con, -20, -100)
                self.arrow.drawAtPoint(CGPointMake(0,0))
            }
            
        case 2:
            let con = UIGraphicsGetCurrentContext()
            CGContextSetShadow(con, CGSizeMake(7, 7), 12)
            
            self.arrow.drawAtPoint(CGPointMake(0,0))
            for _ in 0..<3 {
                CGContextTranslateCTM(con, 20, 100)
                CGContextRotateCTM(con, 30 * CGFloat(M_PI)/180.0)
                CGContextTranslateCTM(con, -20, -100)
                self.arrow.drawAtPoint(CGPointMake(0,0))
            }
            
        case 3:
            let con = UIGraphicsGetCurrentContext()
            CGContextSetShadow(con, CGSizeMake(7, 7), 12)
            
            CGContextBeginTransparencyLayer(con, nil)
            self.arrow.drawAtPoint(CGPointMake(0,0))
            for _ in 0..<3 {
                CGContextTranslateCTM(con, 20, 100)
                CGContextRotateCTM(con, 30 * CGFloat(M_PI)/180.0)
                CGContextTranslateCTM(con, -20, -100)
                self.arrow.drawAtPoint(CGPointMake(0,0))
            }
            CGContextEndTransparencyLayer(con)

        default: break
        }
        
    }
    
    
}
