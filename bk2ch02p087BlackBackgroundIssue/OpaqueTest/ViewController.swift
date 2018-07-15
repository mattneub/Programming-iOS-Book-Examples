// run on iOS 11 and iOS 12 to see changed behavior

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

// uncomment 1 and 3, with 2 commented out
// the view turns black
// but other combinations do not!
// so only certain types of drawing do this in iOS 12

class MyView : UIView {
    override func draw(_ rect: CGRect) {
        let con = UIGraphicsGetCurrentContext()!
        con.setFillColor(UIColor.white.cgColor)
        // con.setFillColor(UIColor.red.cgColor)
        con.fill(CGRect(0,0,50,50))
        con.setFillColor(UIColor.red.cgColor)
        con.move(to:CGPoint(0, 0))
        con.addLine(to:CGPoint(20, 0))
        con.addLine(to:CGPoint(0, 20))
        con.fillPath()

    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = MyView(frame:CGRect(30,30,100,100))
        self.view.addSubview(v)
    }


}

