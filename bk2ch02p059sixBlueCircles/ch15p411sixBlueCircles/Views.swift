import UIKit


class MyView1 : UIView {
    override func drawRect(rect: CGRect) {
        let p = UIBezierPath(ovalInRect: CGRectMake(0,0,100,100))
        UIColor.blueColor().setFill()
        p.fill()
    }
}
class MyView2 : UIView {
    override func drawRect(rect: CGRect) {
        let con = UIGraphicsGetCurrentContext()!
        CGContextAddEllipseInRect(con, CGRectMake(0,0,100,100))
        CGContextSetFillColorWithColor(con, UIColor.blueColor().CGColor)
        CGContextFillPath(con)
    }
}
class MyView3 : UIView {
    override func drawRect(rect: CGRect) {}
    override func drawLayer(layer: CALayer, inContext con: CGContext) {
        UIGraphicsPushContext(con)
        let p = UIBezierPath(ovalInRect: CGRectMake(0,0,100,100))
        UIColor.blueColor().setFill()
        p.fill()
        UIGraphicsPopContext()
    }
}
class MyView4 : UIView {
    override func drawRect(rect: CGRect) {}
    override func drawLayer(layer: CALayer, inContext con: CGContext) {
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
//        UIGraphicsBeginImageContextWithOptions(CGSizeMake(100,100), false, 0)
//        let con = UIGraphicsGetCurrentContext()!
//        CGContextAddEllipseInRect(con, CGRectMake(0,0,100,100))
//        CGContextSetFillColorWithColor(con, UIColor.blueColor().CGColor)
//        CGContextFillPath(con)
//        let im = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        
        self.image = imageOfSize(CGSizeMake(100,100)) {
            let con = UIGraphicsGetCurrentContext()!
            CGContextAddEllipseInRect(con, CGRectMake(0,0,100,100))
            CGContextSetFillColorWithColor(con, UIColor.blueColor().CGColor)
            CGContextFillPath(con)
        }
        
    }
}

/*
NOTE: This structured dance is boring, distracting, confusing (when reading), and error-prone:

UIGraphicsBeginImageContextWithOptions(CGSizeMake(100,100), false, 0)
// do stuff
let im = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()

Since the purpose is to extract the image, it would be nice to replace that with a functional architecture that clearly yields the image. Moreover, such an architecture has the advantage of isolating any local variables used within the "sandwich". In Objective-C you can at least wrap the interior in curly braces to form a scope, but Swift, with its easy closure formation, offers the opportunity for an even clearer presentation, along these lines:
*/

func imageOfSize(size:CGSize, _ opaque:Bool = false, _ closure:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, opaque, 0)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}


