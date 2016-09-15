

import UIKit


class ViewController : UIViewController {
    @IBOutlet var button : UIButton!
    
    var oldButtonCenter : CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.oldButtonCenter = self.button.center // so we can test repeatedly
    }
    
    @IBAction func tapme(sender:AnyObject?) {
        print("tap! (the button's action method)")
    }
    
    let which = 2 // no diff, just proving it's the same for both ways of animating
    
    @IBAction func start(sender:AnyObject?) {
        print("you tapped Start")
        let goal = CGPointMake(100,400)
        self.button.center = self.oldButtonCenter
        
        switch which {
        case 1:
            let opt = UIViewAnimationOptions.AllowUserInteraction
            UIView.animateWithDuration(10, delay: 0, options: opt,
                animations: {
                    self.button.center = goal
                }, completion: nil)
        case 2:
            let ba = CABasicAnimation(keyPath:"position")
            ba.duration = 10
            ba.fromValue = NSValue(CGPoint:self.oldButtonCenter)
            ba.toValue = NSValue(CGPoint:goal)
            self.button.layer.addAnimation(ba, forKey:nil)
            self.button.layer.position = goal
        default: break
        }
    }
}
