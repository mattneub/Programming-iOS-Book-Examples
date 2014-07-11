import UIKit

class ViewController : UIViewController {
    @IBOutlet var v : UIView
    var pOrig : CGPoint!
    
    func animate() {
        var p = self.v.center
        self.pOrig = p
        p.x += 100
        let opts : UIViewAnimationOptions = .Autoreverse | .Repeat
        UIView.animateWithDuration(1, delay:0, options:opts,
            animations:{
            self.v.center = p;
            }, completion: nil)
    }
    
    
    func cancel() {
        UIView.animateWithDuration(0.1, delay:0, options:.BeginFromCurrentState,
            animations: {
            self.v.center = self.pOrig!
            }, completion:nil)
    }
    
    @IBAction func doStart(sender:AnyObject?) {
        self.animate()
    }
    
    @IBAction func doStop(sender:AnyObject?) {
        self.cancel()
    }

    
}
