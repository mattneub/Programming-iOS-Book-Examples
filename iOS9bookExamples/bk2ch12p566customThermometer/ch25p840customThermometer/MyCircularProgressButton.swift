

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
        layer.frame = CGRectMake(0,0,60,60)
        layer.lineWidth = 2
        layer.fillColor = nil
        layer.strokeColor = UIColor.redColor().CGColor
        let b = UIBezierPath(ovalInRect: CGRectMake(3,3,57,57))
        layer.path = b.CGPath
        self.layer.addSublayer(layer)
        layer.zPosition = -1
        layer.strokeStart = 0
        layer.strokeEnd = 0
        layer.setAffineTransform(CGAffineTransformMakeRotation(CGFloat(-M_PI/2.0)))
        self.shapelayer = layer
        
    }
}
