

import UIKit

class MyGradientView : UIView {
    override class var layerClass : AnyClass { return CAGradientLayer.self }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        let lay = self.layer as! CAGradientLayer
        lay.type = .conic
        lay.startPoint = CGPoint(x:0.5,y:0.5)
        lay.endPoint = CGPoint(x:0.5,y:0)
        lay.colors = [UIColor.green.cgColor, UIColor.red.cgColor]
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let shape = CAShapeLayer()
        shape.frame = self.bounds
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        let b = UIBezierPath(ovalIn: shape.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)))
        shape.path = b.cgPath
        shape.lineWidth = 10
        shape.lineCap = .round
        shape.strokeStart = 0.1
        shape.strokeEnd = 0.9
        shape.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        shape.transform = CATransform3DMakeRotation(-.pi/2, 0, 0, 1)
        self.layer.mask = shape
        
    }
    
}

class ViewController: UIViewController {
}

