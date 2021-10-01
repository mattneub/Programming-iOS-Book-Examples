

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



extension CGSize {
    func withDelta(dw:CGFloat, dh:CGFloat) -> CGSize {
        return CGSize(self.width + dw, self.height + dh)
    }
}

class MyShrinkingButton: UIButton {

    override func backgroundRect(forBounds bounds: CGRect) -> CGRect {
        var result = super.backgroundRect(forBounds:bounds)
        if self.isHighlighted {
            result = result.insetBy(dx: 3, dy: 3)
        }
        return result
    }
    
    override var intrinsicContentSize : CGSize {
        return super.intrinsicContentSize.withDelta(dw:25, dh: 20)
    }

    
}
