

import UIKit

// this shows the "right" way to animate a shape layer's path
// an even better approach would be to use `draw(in:)` just to draw, instead of using a shape layer
// but at least this shows it can be done

let FILLC: CGColor = UIColor(red: 236/255, green: 230/255, blue: 156/255, alpha: 1).cgColor
let STROKE: CGColor = UIColor(red: 178/255, green: 0/255, blue: 10/255, alpha: 1).cgColor
let GREEN: UIColor = UIColor(red: 0.175, green: 0.559, blue: 0.147, alpha: 1)

class GreenView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = GREEN
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
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
    @objc var dummy : CGFloat = 0
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == #keyPath(dummy) {
            return true
        }
        return super.needsDisplay(forKey:key)
    }
    override func draw(in ctx: CGContext) {
        var b = (self.presentation() ?? self).bounds
        let unit = b.height/3
        b = CGRect(x: 5, y: unit, width: unit, height: unit)
        // print("layer draw", b)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let path = UIBezierPath(ovalIn: b)
        self.shape?.path = path.cgPath
        self.shape?.frame = self.bounds
        CATransaction.commit()
    }
}
fileprivate class CircleView : UIView {
    override class var layerClass : AnyClass { CircleLayer.self }
}
class ViewController: UIViewController {
    fileprivate lazy var greenView = GreenView(frame: self.targetRect)
    fileprivate lazy var circleView = CircleView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.greenView)
        self.greenView.addSubview(self.circleView)
        self.circleView.frame = self.greenView.bounds
        self.circleView.backgroundColor = .clear
        self.circleView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.circleView.layer.setNeedsDisplay()
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
        }
        let lay = self.circleView.layer as! CircleLayer
        let cur = lay.dummy
        lay.dummy = cur == 10 ? 0 : 10
        let ba = CABasicAnimation(keyPath:#keyPath(CircleLayer.dummy))
        ba.duration = 1
        lay.add(ba, forKey:nil)
    }
}

