
import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

class MyLayer: CALayer {
    let prop: Int
    override init() {
        self.prop = 0
        super.init()
        self.backgroundColor = UIColor.red.cgColor
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // ----
    override init(layer: Any) {
        guard let oldLayer = layer as? MyLayer else {
            fatalError("init(layer:) called with wrong layer type")
        }
        self.prop = oldLayer.prop
        super.init(layer: layer)
        print("here")
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let lay = MyLayer()
        lay.frame = CGRect(40,40,100,100)
        self.view.layer.addSublayer(lay)
        delay(3) {
            lay.position.x += 100
        }
    }


}

