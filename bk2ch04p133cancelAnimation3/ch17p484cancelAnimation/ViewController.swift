import UIKit

class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    
    func animate() {
        let val = NSValue(cgPoint:self.v.center)
        self.v.layer.setValue(val, forKey:"pOrig")
        let opts : UIViewAnimationOptions = [.autoreverse, .repeat]
        UIView.animate(withDuration:1, delay: 0, options: opts,
            animations: {
                self.v.center.x += 100
            })
    }
    
    func cancel() {
        // this works the same way in iOS 8 as before...
        // ...because animation is not additive when existing animation is repeating
        UIView.animate(withDuration:0.1, delay:0,
            options:.beginFromCurrentState,
            animations: {
                if let val = self.v.layer.value(forKey:"pOrig") as? NSValue {
                    self.v.center = val.cgPointValue()
                }
            })
    }
    
    @IBAction func doStart(_ sender:AnyObject?) {
        self.animate()
    }
    
    @IBAction func doStop(_ sender:AnyObject?) {
        self.cancel()
    }
    
    
}
