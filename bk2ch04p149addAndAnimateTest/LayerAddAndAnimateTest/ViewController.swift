

import UIKit

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}
extension CGRect {
    var center : CGPoint {
        return CGPoint(self.midX, self.midY)
    }
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}




class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    var which = 1

    @IBAction func doButton(_ sender: Any) {
        let lay = CALayer()
        let suplay = self.view.layer
        lay.position = suplay.bounds.center
        lay.bounds.size = .zero
        lay.backgroundColor = UIColor.black.cgColor
        switch which {
        case 0:
            // you can't add a sublayer and then animate it implicitly...
            // ...unless you flush the transaction in between
            suplay.addSublayer(lay)
            CATransaction.flush() // comment out to see the problem
            //CATransaction.begin()
            CATransaction.setAnimationDuration(2)
            lay.bounds.size = CGSize(100,100)
            //CATransaction.commit()
        case 1:
            // but you _can_ add a sublayer and then animate it explicitly
            suplay.addSublayer(lay)
            let oldbounds = lay.bounds
            var newbounds = oldbounds
            newbounds.size = CGSize(100,100)
            lay.bounds = newbounds // fine
            let ba = CABasicAnimation(keyPath: #keyPath(CALayer.bounds))
            ba.duration = 2
            ba.fromValue = oldbounds
            ba.toValue = newbounds
            lay.add(ba, forKey:nil)
        default:break
        }
    }
    
}

