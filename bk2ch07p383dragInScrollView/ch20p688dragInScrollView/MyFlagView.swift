
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



class MyFlagView : UIImageView {
    // use our hit test from chapter 5 so that user must tap actual flag drawing
    override func hitTest(_ point: CGPoint, with event: UIEvent!) -> UIView? {
        let inside = self.point(inside: point, with:event)
        if !inside { return nil }
        
        let r = UIGraphicsImageRenderer(size:self.bounds.size)
        let im = r.image {
            ctx in let con = ctx.cgContext
            let lay = self.layer
            lay.render(in:con)
        }

//        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
//        let lay = self.layer
//        lay.render(in:UIGraphicsGetCurrentContext()!)
//        let im = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
        
        let info = CGImageAlphaInfo.alphaOnly.rawValue
        let pixel = UnsafeMutablePointer<UInt8>.allocate(capacity:1)
        defer {
            pixel.deinitialize(count: 1)
            pixel.deallocate()
        }
        pixel[0] = 0
        let sp = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 1, space: sp, bitmapInfo: info)!
        UIGraphicsPushContext(context)
        im.draw(at:CGPoint(-point.x, -point.y))
        UIGraphicsPopContext()
        let p = pixel[0]
        let alpha = Double(p)/255.0
        let transparent = alpha < 0.01
        return transparent ? nil : self
    }
}
