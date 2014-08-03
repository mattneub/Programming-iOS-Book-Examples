
import UIKit

class MyProgressView: UIView {
    
    var value : Float = 0
    
    override func drawRect(rect: CGRect) {
        let c = UIGraphicsGetCurrentContext()
        UIColor.whiteColor().set()
        let ins : CGFloat = 2.0
        let r = CGRectInset(self.bounds, ins, ins)
        let radius : CGFloat = r.size.height / 2.0
        let mpi = CGFloat(M_PI)
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, CGRectGetMaxX(r) - radius, ins)
        CGPathAddArc(path, nil,
            radius+ins, radius+ins, radius, -mpi/2.0, mpi/2.0, true)
        CGPathAddArc(path, nil,
            CGRectGetMaxX(r) - radius, radius+ins, radius, mpi/2.0, -mpi/2.0, true)
        CGPathCloseSubpath(path)
        CGContextAddPath(c, path)
        CGContextSetLineWidth(c, 2)
        CGContextStrokePath(c)
        CGContextAddPath(c, path)
        CGContextClip(c)
        CGContextFillRect(c, CGRectMake(
            r.origin.x, r.origin.y, r.size.width * CGFloat(self.value), r.size.height))
    }

}
