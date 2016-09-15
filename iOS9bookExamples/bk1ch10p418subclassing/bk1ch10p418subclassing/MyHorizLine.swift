

import UIKit

class MyHorizLine: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.backgroundColor = UIColor.clearColor()
    }
    override func drawRect(rect: CGRect) {
        let c = UIGraphicsGetCurrentContext()!
        CGContextMoveToPoint(c, 0, 0)
        CGContextAddLineToPoint(c, self.bounds.size.width, 0)
        CGContextStrokePath(c)
    }


}
