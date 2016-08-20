import UIKit


func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


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


class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    
    let which = 2

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var lay1 = CALayer()
        switch which {
        case 1: break
        case 2:
            lay1 = CATransformLayer()
        default: break
        }
        
        lay1.frame = self.v.layer.bounds
        self.v.layer.addSublayer(lay1)
        
        let f = CGRect(0,0,100,100)
        
        let lay2 = CALayer()
        lay2.frame = f
        lay2.backgroundColor = UIColor.blue.cgColor
        lay1.addSublayer(lay2)
        let lay3 = CALayer()
        lay3.frame = f.offsetBy(dx: 20, dy: 30)
        lay3.backgroundColor = UIColor.green.cgColor
        lay3.zPosition = 10
        lay1.addSublayer(lay3)

        delay(2) {
            lay1.transform = CATransform3DMakeRotation(.pi, 0, 1, 0)
        }
    }
    
}
