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


class MyView : UIView {
    override func draw(_ rect: CGRect) {
        let con = UIGraphicsGetCurrentContext()!
        con.setFillColor(UIColor.blue.cgColor)
        con.fill(CGRect(0,0,0,0))
        // but the context is transparent if we comment out the next line
        // I regard this as a bug (not fixed in beta 5)
        // okay, this is fixed in beta 6; we get an opaque context in both cases
        con.setFillColor(UIColor.red.cgColor)
        con.fill(CGRect(0,0,0,0))
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = MyView(frame:CGRect(30,30,100,100))
        v.layer.borderWidth = 1
        self.view.addSubview(v)
    }


}

