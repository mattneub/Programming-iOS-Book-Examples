import UIKit

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}


class MyView1 : UIView {
    override func draw(_ rect: CGRect) {
        let p = UIBezierPath(ovalIn: CGRect(0,0,100,100))
        UIColor.blue().setFill()
        p.fill()
    }
}
class MyView2 : UIView {
    override func draw(_ rect: CGRect) {
        let con = UIGraphicsGetCurrentContext()!
        con.addEllipse(inRect:CGRect(0,0,100,100))
        con.setFillColor(UIColor.blue().cgColor)
        con.fillPath()
    }
}
class MyView3 : UIView {
    override func draw(_ rect: CGRect) {}
    override func draw(_ layer: CALayer, in con: CGContext) {
        UIGraphicsPushContext(con)
        let p = UIBezierPath(ovalIn: CGRect(0,0,100,100))
        UIColor.blue().setFill()
        p.fill()
        UIGraphicsPopContext()
    }
}
class MyView4 : UIView {
    override func draw(_ rect: CGRect) {}
    override func draw(_ layer: CALayer, in con: CGContext) {
        con.addEllipse(inRect:CGRect(0,0,100,100))
        con.setFillColor(UIColor.blue().cgColor)
        con.fillPath()
    }
}
class MyImageView1 : UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        UIGraphicsBeginImageContextWithOptions(CGSize(width:100,height:100), false, 0)
        let p = UIBezierPath(ovalIn: CGRect(0,0,100,100))
        UIColor.blue().setFill()
        p.fill()
        let im = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.image = im
    }
}
class MyImageView2 : UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
//        UIGraphicsBeginImageContextWithOptions(CGSize(100,100), false, 0)
//        let con = UIGraphicsGetCurrentContext()!
//        CGContextAddEllipseInRect(con, CGRect(0,0,100,100))
//        CGContextSetFillColorWithColor(con, UIColor.blue().cgColor)
//        CGContextFillPath(con)
//        let im = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
        
        self.image = imageOfSize(CGSize(width:100,height:100)) {
            let con = UIGraphicsGetCurrentContext()!
            con.addEllipse(inRect:CGRect(0,0,100,100))
            con.setFillColor(UIColor.blue().cgColor)
            con.fillPath()
        }
        
    }
}

/*
NOTE: This structured dance is boring, distracting, confusing (when reading), and error-prone:

UIGraphicsBeginImageContextWithOptions(CGSize(100,100), false, 0)
// do stuff
let im = UIGraphicsGetImageFromCurrentImageContext()!
UIGraphicsEndImageContext()

Since the purpose is to extract the image, it would be nice to replace that with a functional architecture that clearly yields the image. Moreover, such an architecture has the advantage of isolating any local variables used within the "sandwich". In Objective-C you can at least wrap the interior in curly braces to form a scope, but Swift, with its easy closure formation, offers the opportunity for an even clearer presentation, along these lines:
*/

func imageOfSize(_ size:CGSize, _ opaque:Bool = false, _ closure:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, opaque, 0)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return result
}


