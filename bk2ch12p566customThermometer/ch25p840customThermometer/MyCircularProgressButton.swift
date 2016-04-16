

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
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layer = CAShapeLayer()
        layer.frame = CGRect(0,0,60,60)
        layer.lineWidth = 2
        layer.fillColor = nil
        layer.strokeColor = UIColor.red().cgColor
        let b = UIBezierPath(ovalIn: CGRect(3,3,57,57))
        layer.path = b.cgPath
        self.layer.addSublayer(layer)
        layer.zPosition = -1
        layer.strokeStart = 0
        layer.strokeEnd = 0
        layer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(-M_PI/2.0)))
        self.shapelayer = layer
        
    }
}
