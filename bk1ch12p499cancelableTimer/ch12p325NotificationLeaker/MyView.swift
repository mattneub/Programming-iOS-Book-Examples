
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
    
    override func draw(_ rect: CGRect) {
        let con = UIGraphicsGetCurrentContext()!
        let locs : [CGFloat] = [ 0.0, 0.5, 1.0 ]
        let colors : [CGFloat] = [
            0.8, 0.4, // starting color, transparent light gray
            0.1, 0.5, // intermediate color, darker less transparent gray
            0.8, 0.4, // ending color, transparent light gray
        ]
        let sp = CGColorSpaceCreateDeviceGray()
        let grad = CGGradient(colorSpace: sp, colorComponents: colors, locations: locs, count: 3)
        con.drawLinearGradient(grad!, start: CGPoint(x:89,y:0), end: CGPoint(x:111,y:0), options:[])

    }
}
