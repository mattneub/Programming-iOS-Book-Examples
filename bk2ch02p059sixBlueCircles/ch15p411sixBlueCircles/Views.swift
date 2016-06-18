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
        let f = UIGraphicsImageRendererFormat()
        // scale defaults to main screen scale
        // opaque defaults to false
        // extendedRange defaults to whatever hardware supposes
        _ = f // thus, usually no need for an explicit format!
        let r = UIGraphicsImageRenderer(size:CGSize(width:100,height:100))
        self.image = r.image { _ in
            let p = UIBezierPath(ovalIn: CGRect(0,0,100,100))
            UIColor.blue().setFill()
            p.fill()
        }
//        UIGraphicsBeginImageContextWithOptions(CGSize(width:100,height:100), false, 0)
//        let p = UIBezierPath(ovalIn: CGRect(0,0,100,100))
//        UIColor.blue().setFill()
//        p.fill()
//        let im = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        self.image = im
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
        
//        self.image = imageOfSize(CGSize(width:100,height:100)) {
//            let con = UIGraphicsGetCurrentContext()!
//            con.addEllipse(inRect:CGRect(0,0,100,100))
//            con.setFillColor(UIColor.blue().cgColor)
//            con.fillPath()
//        }
        
        // okay, here's the deal:
        // the context passed into the function is not a CGContext
        // but it _has_ a CGContext, and we are _in_ that context
        
        // alternatively, it has its own elementary fill, stroke, and clip methods
//        public func fill(_ rect: CGRect)
//        public func fill(_ rect: CGRect, blendMode: CGBlendMode)
//        public func stroke(_ rect: CGRect)
//        public func stroke(_ rect: CGRect, blendMode: CGBlendMode)
//        public func clip(to rect: CGRect)
        
        // here, though, I want to show the full CGContext way of drawing
        
        let r = UIGraphicsImageRenderer(size:CGSize(width:100,height:100))
        self.image = r.image {ctx in
            let con = ctx.cgContext
            // NB: we are _in_ this context, so could say instead:
            // let con = UIGraphicsGetCurrentContext()!
            con.addEllipse(inRect:CGRect(0,0,100,100))
            con.setFillColor(UIColor.blue().cgColor)
            con.fillPath()
        }
        
    }
}

// Well, I guess we won't be needing _this_ any more! :)

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


