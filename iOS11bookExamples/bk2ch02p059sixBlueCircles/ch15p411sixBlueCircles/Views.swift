import UIKit

func imageOfSize(_ size:CGSize, opaque:Bool = false, closure: () -> ()) -> UIImage {
    if #available(iOS 10.0, *) {
        let f = UIGraphicsImageRendererFormat.default()
        f.opaque = opaque
        let r = UIGraphicsImageRenderer(size: size, format: f)
        return r.image {_ in closure()}
    } else {
        UIGraphicsBeginImageContextWithOptions(size, opaque, 0)
        closure()
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
}

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



class MyView1 : UIView {
    override func draw(_ rect: CGRect) {
        let p = UIBezierPath(ovalIn: CGRect(0,0,100,100))
        UIColor.blue.setFill()
        p.fill()
    }
}
class MyView2 : UIView {
    override func draw(_ rect: CGRect) {
        let con = UIGraphicsGetCurrentContext()!
        con.addEllipse(in:CGRect(0,0,100,100))
        con.setFillColor(UIColor.blue.cgColor)
        con.fillPath()
    }
}
class MyView3 : UIView {
    override func draw(_ rect: CGRect) {}
    override func draw(_ layer: CALayer, in con: CGContext) {
        UIGraphicsPushContext(con)
        let p = UIBezierPath(ovalIn: CGRect(0,0,100,100))
        UIColor.blue.setFill()
        p.fill()
        UIGraphicsPopContext()
    }
}
class MyView4 : UIView {
    override func draw(_ rect: CGRect) {}
    override func draw(_ layer: CALayer, in con: CGContext) {
        con.addEllipse(in:CGRect(0,0,100,100))
        con.setFillColor(UIColor.blue.cgColor)
        con.fillPath()
    }
}
class MyImageView1 : UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        let f = UIGraphicsImageRendererFormat.default()
        // scale defaults to main screen scale
        // opaque defaults to false
        print(f.scale)
        print(f.opaque)
        // extendedRange defaults to whatever hardware supposes
        _ = f // thus, usually no need for an explicit format!
        // new in iOS 11:
        let f2 = UIGraphicsImageRendererFormat(for: self.traitCollection)
        print(f2.scale)
        print(f2.opaque)
        let r = UIGraphicsImageRenderer(size:CGSize(100,100))
        self.image = r.image { _ in
            let p = UIBezierPath(ovalIn: CGRect(0,0,100,100))
            UIColor.blue.setFill()
            p.fill()
        }
    }
}
class MyImageView2 : UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        // the context passed into the function is not a CGContext
        // but it _has_ a CGContext, and we are _in_ that context
        
        // alternatively, it has its own elementary fill, stroke, and clip methods
//        public func fill(_ rect: CGRect)
//        public func fill(_ rect: CGRect, blendMode: CGBlendMode)
//        public func stroke(_ rect: CGRect)
//        public func stroke(_ rect: CGRect, blendMode: CGBlendMode)
//        public func clip(to rect: CGRect)
        
        // here, though, I want to show the full CGContext way of drawing
        
        var which : Int {return 0}
        switch which {
        case 0:
            let r = UIGraphicsImageRenderer(size:CGSize(100,100))
            self.image = r.image {ctx in
                // let con = ctx.cgContext
                // could say that, but the old way works still
                let con = UIGraphicsGetCurrentContext()!
                con.addEllipse(in:CGRect(0,0,100,100))
                con.setFillColor(UIColor.blue.cgColor)
                con.fillPath()
            }
        case 1: // just showing how to use my utility
            self.image = imageOfSize(CGSize(100, 100)) {
                let con = UIGraphicsGetCurrentContext()!
                con.addEllipse(in:CGRect(0,0,100,100))
                con.setFillColor(UIColor.blue.cgColor)
                con.fillPath()
            }
        default:break
        }
    }
}

