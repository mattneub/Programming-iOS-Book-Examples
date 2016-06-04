

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



class ViewController : UIViewController {
    @IBOutlet var button : UIButton!
    
    var oldButtonCenter : CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.oldButtonCenter = self.button.center // so we can test repeatedly
    }
    
    @IBAction func tapme(_ sender:AnyObject?) {
        print("tap! (the button's action method)")
    }
    
    let which = 2 // no diff, just proving it's the same for both ways of animating
    
    @IBAction func start(_ sender:AnyObject?) {
        print("you tapped Start")
        let goal = CGPoint(100,400)
        self.button.center = self.oldButtonCenter
        
        switch which {
        case 1:
            let opt = UIViewAnimationOptions.allowUserInteraction
            UIView.animate(withDuration:10, delay: 0, options: opt,
                animations: {
                    self.button.center = goal
                })
        case 2:
            let ba = CABasicAnimation(keyPath:"position")
            ba.duration = 10
            ba.fromValue = NSValue(cgPoint:self.oldButtonCenter)
            ba.toValue = NSValue(cgPoint:goal)
            self.button.layer.add(ba, forKey:nil)
            self.button.layer.position = goal
        default: break
        }
    }
}
