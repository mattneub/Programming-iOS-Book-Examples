import UIKit


func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var lay1 = CALayer()
        let which = 1
        switch which {
        case 1: break
        case 2:
            lay1 = CATransformLayer()
        default: break
        }
        
        lay1.frame = self.v.layer.bounds
        self.v.layer.addSublayer(lay1)
        
        let f = CGRectMake(0,0,100,100)
        
        let lay2 = CALayer()
        lay2.frame = f
        lay2.backgroundColor = UIColor.blueColor().CGColor
        lay1.addSublayer(lay2)
        let lay3 = CALayer()
        lay3.frame = f.rectByOffsetting(dx: 20, dy: 30)
        lay3.backgroundColor = UIColor.greenColor().CGColor
        lay3.zPosition = 10
        lay1.addSublayer(lay3)

        delay(2) {
            lay1.transform = CATransform3DMakeRotation(CGFloat(M_PI), 0, 1, 0)
        }
    }
    
}
