

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



class RootViewController: UIViewController {
    
    let which = 1
    
    override func loadView() {
        let v = UIView()
        v.backgroundColor = .green
        self.view = v
        let label = UILabel()
        v.addSubview(label)
        label.text = "Hello, World!"

        switch which {
        case 1:
            label.autoresizingMask = [
                .flexibleTopMargin,
                .flexibleLeftMargin,
                .flexibleBottomMargin,
                .flexibleRightMargin]
            label.sizeToFit()
            label.center = CGPoint(v.bounds.midX, v.bounds.midY)
            label.frame = label.frame.integral

        case 2:
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo:self.view.centerXAnchor),
                label.centerYAnchor.constraint(equalTo:self.view.centerYAnchor),
                ])
        default: break
        }
    }

}
