

import UIKit

class MyBoundedLabel: UILabel {
    
    override func drawTextInRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        CGContextStrokeRect(context, CGRectInset(self.bounds, 1.0, 1.0))
        super.drawTextInRect(CGRectInset(rect, 5.0, 5.0))
    }

}
