

import UIKit

extension CGSize {
    func sizeByDelta(#dw:CGFloat, dh:CGFloat) -> CGSize {
        return CGSizeMake(self.width + dw, self.height + dh)
    }
}

class MyShrinkingButton: UIButton {

    override func backgroundRectForBounds(bounds: CGRect) -> CGRect {
        var result = super.backgroundRectForBounds(bounds)
        if self.highlighted {
            result.inset(dx: 3, dy: 3)
        }
        return result
    }
    
    override func intrinsicContentSize() -> CGSize {
        return super.intrinsicContentSize().sizeByDelta(dw:25, dh: 20)
    }

    
}
