

import UIKit

class MyCircularProgressButton : UIButton {
    var progress : Float = 0 {
        didSet {
            self.shapelayer?.strokeEnd = CGFloat(self.progress)
        }
    }
    private weak var shapelayer : CAShapeLayer?
    override func layoutSubviews() {
        super.layoutSubviews()
        guard self.shapelayer == nil else {return}
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.lineWidth = 2
        layer.fillColor = nil
        layer.strokeColor = UIColor.red.cgColor
        let b = UIBezierPath(ovalIn: self.bounds.insetBy(dx: 3, dy: 3))
        layer.path = b.cgPath
        layer.strokeStart = 0
        layer.strokeEnd = 0
        layer.setAffineTransform(CGAffineTransform(rotationAngle: -.pi/2.0))
        self.layer.addSublayer(layer)
        self.shapelayer = layer
    }
}
