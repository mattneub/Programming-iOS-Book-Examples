

import UIKit

class MyCircularProgressButton : UIButton {
    
    var progress : Float = 0 {
        didSet {
            if let layer = self.shapelayer {
                layer.strokeEnd = CGFloat(self.progress)
            }
        }
    }
    
    private var shapelayer : CAShapeLayer!
    private var didLayout = false
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard !self.didLayout else {return}
        self.didLayout = true
        print(self.bounds)
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.lineWidth = 2
        layer.fillColor = nil
        layer.strokeColor = UIColor.red.cgColor
        let b = UIBezierPath(ovalIn: self.bounds.insetBy(dx: 3, dy: 3))
        b.apply(CGAffineTransform(translationX: -self.bounds.width/2, y: -self.bounds.height/2))
        b.apply(CGAffineTransform(rotationAngle: -.pi/2.0))
        b.apply(CGAffineTransform(translationX: self.bounds.width/2, y: self.bounds.height/2))

        layer.path = b.cgPath
        self.layer.addSublayer(layer)
        layer.zPosition = -1
        layer.strokeStart = 0
        layer.strokeEnd = 0
        // layer.setAffineTransform(CGAffineTransform(rotationAngle: -.pi/2.0))
        self.shapelayer = layer
        
    }
}
