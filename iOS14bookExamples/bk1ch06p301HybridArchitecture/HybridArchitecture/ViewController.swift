

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
extension CGRect {
    var center : CGPoint {
        return CGPoint(self.midX, self.midY)
    }
}

var useStoryboard = false

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if useStoryboard {
            return
        }
        self.view.backgroundColor = .red
        let lab = UILabel()
        lab.text = "Hello world"
        lab.textColor = .white
        lab.sizeToFit()
        lab.center = self.view.bounds.center
        self.view.addSubview(lab)
    }


}

