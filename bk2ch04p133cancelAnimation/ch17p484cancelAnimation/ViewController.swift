import UIKit

class ViewController : UIViewController {
    @IBOutlet var v : UIView
    var pFinal : CGPoint!
    
    func animate() {
        var p = self.v.center
        p.x += 100
        self.pFinal = p
        UIView.animateWithDuration(4) {
            self.v.center = p
        }
    }
    
    func cancelOld() {
        // old code:
        UIView.animateWithDuration(0.1, delay:0.1, options:.BeginFromCurrentState,
            animations: {
            var p = self.pFinal!
            p.x += 1
            self.v.center = p
            }, completion: {
                _ in
                self.v.center = self.pFinal
            })
        // but in iOS 8 that no longer works...
        // ...because starting a new animation is additive
    }
    
    func cancel() {
        self.v.layer.position = self.v.layer.presentationLayer().position
        self.v.layer.removeAllAnimations()
        UIView.animateWithDuration(0.1) {
            self.v.center = self.pFinal
        }
    }
    
    @IBAction func doStart(sender:AnyObject?) {
        self.animate()
    }
    
    @IBAction func doStop(sender:AnyObject?) {
        self.cancel()
    }

    
}
