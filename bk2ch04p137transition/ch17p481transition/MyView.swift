import UIKit

class MyView : UIView {
    
    var reverse = false
    
    override func drawRect(rect: CGRect)  {
        let f = self.bounds.insetBy(dx: 10, dy: 10)
        let con = UIGraphicsGetCurrentContext()!
        if self.reverse {
            CGContextStrokeEllipseInRect(con, f)
        }
        else {
            CGContextStrokeRect(con, f)
        }
    }
    
}
