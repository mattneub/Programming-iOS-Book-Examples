
import UIKit

// showing how a private façade can make a publicly immutable class mutable internally

class StringDrawer {
    @NSCopying var attributedString : NSAttributedString!
    private var mutableAttributedString : NSMutableAttributedString! {
        get {
            if self.attributedString == nil {return nil}
            return NSMutableAttributedString(
                attributedString:self.attributedString)
        }
        set {
            self.attributedString = newValue
        }
    }
}


class MyView : UIView {
    
    // showing how no memory management is needed on CFTypeRefs
    
    override func drawRect(rect: CGRect) {
        let con = UIGraphicsGetCurrentContext()!
        let locs : [CGFloat] = [ 0.0, 0.5, 1.0 ]
        let colors : [CGFloat] = [
            0.8, 0.4, // starting color, transparent light gray
            0.1, 0.5, // intermediate color, darker less transparent gray
            0.8, 0.4, // ending color, transparent light gray
        ]
        let sp = CGColorSpaceCreateDeviceGray()
        let grad = CGGradientCreateWithColorComponents (sp, colors, locs, 3)
        CGContextDrawLinearGradient (
            con, grad, CGPointMake(89,0), CGPointMake(111,0), [])

    }
}
