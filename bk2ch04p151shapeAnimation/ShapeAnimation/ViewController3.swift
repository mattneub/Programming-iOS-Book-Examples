

import UIKit

// this is a weird one, I'm not even sure what's going on :)

fileprivate class CircleLayer : CALayer {
    weak var shape : CAShapeLayer?
    override init() {
        super.init()
        let shape = CAShapeLayer()
        self.addSublayer(shape)
        self.shape = shape
        self.shape?.lineWidth = 5
        self.shape?.fillColor = FILLC
        self.shape?.strokeColor = STROKE
    }
    override init(layer: Any) {
        self.shape = (layer as! CircleLayer).shape
        super.init(layer: layer)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func path(for newBounds: CGRect) -> CGPath {
        var b = newBounds
        let unit = b.height/3
        b = CGRect(x: 5, y: unit, width: unit, height: unit)
        let path = UIBezierPath(ovalIn: b)
        return path.cgPath
    }
    func update() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.shape?.path = self.path(for: self.bounds)
        self.shape?.frame = self.bounds
        CATransaction.commit()
    }
}
fileprivate class CircleView3 : UIView {
    override class var layerClass : AnyClass { CircleLayer.self }
}
class ViewController3: UIViewController {
    fileprivate lazy var greenView = GreenView(frame: self.targetRect)
    fileprivate lazy var circleView = CircleView3()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.greenView)
        self.greenView.addSubview(self.circleView)
        self.circleView.frame = self.greenView.bounds
        self.circleView.backgroundColor = .clear
        self.circleView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.circleView.layer.setNeedsDisplay()
        (self.circleView.layer as! CircleLayer).update()
    }
    var big = true
    var targetRect : CGRect {
        var rect = CGRect(x: 20, y: 70, width: 250, height: 400)
        if self.big {
            rect = CGRect(x: 90, y: 130, width: 150, height: 150)
        }
        return rect
    }
    @IBAction func doButton(_ sender: Any) {
        self.big.toggle()
        UIView.animate(withDuration: 1, delay: 0, options: [.layoutSubviews]) {
            self.greenView.frame = self.targetRect
            let lay = self.circleView.layer as! CircleLayer
            let oldPath = lay.shape?.path
            let newPath = lay.path(for: self.greenView.bounds)
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            lay.shape?.path = newPath
            CATransaction.commit()
            let ba = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
            ba.fromValue = oldPath
            ba.toValue = newPath
            ba.duration = 1
            lay.shape?.add(ba, forKey: nil)
            
            return;
            let oldBounds = lay.shape?.bounds
            let newBounds = self.greenView.bounds
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            lay.shape?.bounds = newBounds
            CATransaction.commit()
            let ba2 = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.bounds))
            ba2.fromValue = oldBounds
            ba2.toValue = newBounds
            ba2.duration = 1
            lay.shape?.add(ba2, forKey: nil)

        }
    }
}

