

import UIKit

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




// hit-testing on the non-transparent portion of a drawing
// (here, it's the black ellipse)

class MyView : UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let lay = CALayer()
        lay.frame = self.layer.bounds
        self.layer.addSublayer(lay)
        let t = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.addGestureRecognizer(t)
    }
    
    func tap() {
        print("tap")
    }
    
    override func draw(_ rect: CGRect) {
        guard let subs = self.layer.sublayers else {return}
        let lay = subs[subs.count-1]
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        let con = UIGraphicsGetCurrentContext()!
        let r = self.bounds.insetBy(dx: 30, dy: 30)
        con.saveGState()
        con.translate(x: self.bounds.width/2.0, y: self.bounds.height/2.0)
        con.rotate(byAngle: CGFloat(M_PI)/10.0)
        con.translate(x: -self.bounds.size.width/2.0, y: -self.bounds.size.height/2.0)
        con.fillEllipse(in:r)
        con.restoreGState()
        let im = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        lay.contents = im.cgImage
    }
    
    override func hitTest(_ point: CGPoint, with e: UIEvent?) -> UIView? {
        let inside = self.point(inside:point, with:e)
        if !inside { return nil }
        
        guard let subs = self.layer.sublayers else {return nil}
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        let lay = subs[subs.count-1]
        lay.render(in:UIGraphicsGetCurrentContext()!)
        let im = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let info = CGImageAlphaInfo.alphaOnly.rawValue
        let pixel = UnsafeMutablePointer<CUnsignedChar>(allocatingCapacity:1)
        defer {
            pixel.deinitialize(count: 1)
            pixel.deallocateCapacity(1)
        }
        pixel[0] = 0
        let sp = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: pixel,
            width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 1,
            space: sp, bitmapInfo: info, releaseCallback:nil, releaseInfo: nil)!
        UIGraphicsPushContext(context)
        im.draw(at:CGPoint(-point.x, -point.y))
        UIGraphicsPopContext()
        let p = pixel[0]
        let alpha = Double(p)/255.0
        let transparent = alpha < 0.01
        return transparent ? nil : self
    }
    
}
