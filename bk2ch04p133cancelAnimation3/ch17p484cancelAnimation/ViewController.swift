import UIKit

class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    
    func animate() {
        let val = NSValue(CGPoint:self.v.center)
        self.v.layer.setValue(val, forKey:"pOrig")
        let opts : UIViewAnimationOptions = .Autoreverse | .Repeat
        UIView.animateWithDuration(1, delay: 0, options: opts,
            animations: {
                self.v.center.x += 100
            }, completion: nil)
    }
    
    
    func cancel() {
        // this works the same way in iOS 8 as before...
        // ...because animation is not additive when existing animation is repeating
        UIView.animateWithDuration(0.1, delay:0,
            options:.BeginFromCurrentState,
            animations: {
                if let val = self.v.layer.valueForKey("pOrig") as? NSValue {
                    self.v.center = val.CGPointValue()
                }
            }, completion:nil)
    }
    
    @IBAction func doStart(sender:AnyObject?) {
        self.animate()
    }
    
    @IBAction func doStop(sender:AnyObject?) {
        self.cancel()
    }
    
    
}
