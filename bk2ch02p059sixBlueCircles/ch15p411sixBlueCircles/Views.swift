import UIKit
import QuartzCore

class MyView1 : UIView {
    override func drawRect(rect: CGRect) {
        let p = UIBezierPath(ovalInRect: CGRectMake(0,0,100,100))
        UIColor.blueColor().setFill()
        p.fill()
    }
}
class MyView2 : UIView {
    override func drawRect(rect: CGRect) {
        let con = UIGraphicsGetCurrentContext()
        CGContextAddEllipseInRect(con, CGRectMake(0,0,100,100))
        CGContextSetFillColorWithColor(con, UIColor.blueColor().CGColor)
        CGContextFillPath(con)
    }
}
class MyView3 : UIView {
    override func drawRect(rect: CGRect) {}
    override func drawLayer(layer: CALayer!, inContext con: CGContext!) {
        UIGraphicsPushContext(con)
        let p = UIBezierPath(ovalInRect: CGRectMake(0,0,100,100))
        UIColor.blueColor().setFill()
        p.fill()
        UIGraphicsPopContext()
    }
}
class MyView4 : UIView {
    override func drawRect(rect: CGRect) {}
    override func drawLayer(layer: CALayer!, inContext con: CGContext!) {
        CGContextAddEllipseInRect(con, CGRectMake(0,0,100,100))
        CGContextSetFillColorWithColor(con, UIColor.blueColor().CGColor)
        CGContextFillPath(con)
    }
}
class MyImageView1 : UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(100,100), false, 0)
        let p = UIBezierPath(ovalInRect: CGRectMake(0,0,100,100))
        UIColor.blueColor().setFill()
        p.fill()
        let im = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = im
    }
}
class MyImageView2 : UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(100,100), false, 0)
        let con = UIGraphicsGetCurrentContext()
        CGContextAddEllipseInRect(con, CGRectMake(0,0,100,100))
        CGContextSetFillColorWithColor(con, UIColor.blueColor().CGColor)
        CGContextFillPath(con)
        let im = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = im
    }
}



