

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

/*
 Not in the book.
 The idea is to demonstrate that using UIView mask, rather than CALayer mask,
 does have one clear advantage: although you don't get _automatic_ resizing
 of the mask view when the view resized, you can use view property animation
 to animate the layer along with the view _manually_.
 The view contains two labels just to demonstrate that layout of subviews
 proceeds coherently during the animation.
 */

class CircleMaskView : UIView {
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.isOpaque = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        let con = UIGraphicsGetCurrentContext()
        UIColor.black.setFill()
        con?.fillEllipse(in: rect)
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var yellowView: UIView!

    var didInitialLayout = false
    override func viewDidLayoutSubviews() {
        if !didInitialLayout {
            didInitialLayout = true
            self.yellowView.center = self.view.bounds.center
            let mask = CircleMaskView(frame:self.yellowView.bounds)
            self.yellowView.mask = mask
        }
    }
    
    @IBAction func doButton(_ sender: Any) {
        let currect = self.yellowView.bounds
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear, .autoreverse], animations: {
            let rect = CGRect(origin: .zero, size: CGSize(200, 200))
            self.yellowView.bounds = rect
            self.yellowView.mask!.frame = rect
        }) { _ in
            self.yellowView.bounds = currect
            self.yellowView.mask!.frame = currect
        }
    }
    

}

