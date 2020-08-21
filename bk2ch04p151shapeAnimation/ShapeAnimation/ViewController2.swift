
import UIKit

// this shows the most common mistake, where people don't realize that at the start of the animation
// the background view already has its size and position at the _end_ of the animation
// therefore setting the shape layer's path causes it to _jump_ to its _final_ size and position

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
    func update() {
        var b = self.bounds
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
fileprivate class CircleView2 : UIView {
    override class var layerClass : AnyClass { CircleLayer.self }
}
class ViewController2: UIViewController {
    fileprivate lazy var greenView = GreenView(frame: self.targetRect)
    fileprivate lazy var circleView = CircleView2()
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
            lay.frame = self.greenView.bounds
            lay.update()
        }
    }
}

