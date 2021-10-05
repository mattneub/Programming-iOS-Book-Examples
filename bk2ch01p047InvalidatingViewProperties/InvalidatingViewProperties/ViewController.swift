

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

// invalidating view properties

class MyView: UIView {
    enum Coolness {
        case cool, lukewarm, hot
    }
    @Invalidating(.display, .layout) var coolness : Coolness = .cool
    override func draw(_ rect: CGRect) {
        print("I'm redrawing")
        super.draw(rect)
    }
    override func layoutSubviews() {
        print("I'm laying out")
        super.layoutSubviews()
    }
}
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let v = MyView(frame:.init(x: 100, y: 100, width: 100, height: 100))
        v.backgroundColor = .red
        self.view.addSubview(v)
        delay(2) {
            print("here we go")
            v.coolness = .hot
        }
    }
}

