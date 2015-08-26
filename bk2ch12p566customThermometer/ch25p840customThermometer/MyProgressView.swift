
import UIKit

class MyProgressView: UIView {
    
    var value : CGFloat = 0
    
    override func drawRect(rect: CGRect) {
        let c = UIGraphicsGetCurrentContext()!
        UIColor.whiteColor().set()
        let ins : CGFloat = 2.0
        let r = self.bounds.insetBy(dx: ins, dy: ins)
        let radius : CGFloat = r.size.height / 2.0
        let mpi = CGFloat(M_PI)
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, r.maxX - radius, ins)
        CGPathAddArc(path, nil,
            radius+ins, radius+ins, radius, -mpi/2.0, mpi/2.0, true)
        CGPathAddArc(path, nil,
            r.maxX - radius, radius+ins, radius, mpi/2.0, -mpi/2.0, true)
        CGPathCloseSubpath(path)
        CGContextAddPath(c, path)
        CGContextSetLineWidth(c, 2)
        CGContextStrokePath(c)
        CGContextAddPath(c, path)
        CGContextClip(c)
        CGContextFillRect(c, CGRectMake(
            r.origin.x, r.origin.y, r.size.width * self.value, r.size.height))
    }

}
