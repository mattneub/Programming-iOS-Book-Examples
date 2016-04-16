import UIKit

class MyView : UIView {
    
    var reverse = false
    
    override func draw(_ rect: CGRect)  {
        let f = self.bounds.insetBy(dx: 10, dy: 10)
        let con = UIGraphicsGetCurrentContext()!
        if self.reverse {
            con.strokeEllipse(in:f)
        }
        else {
            con.stroke(f)
        }
    }
    
}
