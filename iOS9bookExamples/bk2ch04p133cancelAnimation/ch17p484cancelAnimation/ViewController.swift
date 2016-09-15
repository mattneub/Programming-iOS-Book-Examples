import UIKit


class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    var pOrig : CGPoint!
    var pFinal : CGPoint!
    
    func animate() {
        self.pOrig = self.v.center
        self.pFinal = self.v.center
        self.pFinal.x += 100
        UIView.animateWithDuration(4, animations: {
            self.v.center = self.pFinal
            }, completion: {
                _ in
                print("finished initial animation")
        })
    }
    
    let which = 5

    func cancel() {
        switch which {
        case 1:
            // simplest possible solution: just kill it dead
            self.v.layer.removeAllAnimations()
        case 2:
            // iOS 7 and before; no longer works in iOS 8
            let opts = UIViewAnimationOptions.BeginFromCurrentState
            UIView.animateWithDuration(0.1, delay:0.1, options:opts,
                animations: {
                    var p = self.pFinal!
                    p.x += 1
                    self.v.center = p
                }, completion: {
                    _ in
                    self.v.center = self.pFinal
            })
        case 3:
            // comment out the first two lines here to see what "additive" means
            // the new animation does not remove the original animation...
            // so the new animation just completes and the original proceeds as before
            // to prevent that, we have to intervene directly
            self.v.layer.position = (self.v.layer.presentationLayer() as! CALayer).position
            self.v.layer.removeAllAnimations()
            UIView.animateWithDuration(0.1, animations: {
                self.v.center = self.pFinal
                }, completion: {
                    _ in
                    print ("finished second animation")
            })
        case 4:
            // same thing except this time we decide to return to the original position
            // we will get there, but it will take us the rest of the original 4 seconds...
            // unless we intervene directly
            self.v.layer.position = (self.v.layer.presentationLayer() as! CALayer).position
            self.v.layer.removeAllAnimations()
            UIView.animateWithDuration(0.1, animations: {
                self.v.center = self.pOrig // need to have recorded original position
                }, completion: {
                    _ in
                    print ("finished second animation")
            })
        case 5:
            // cancel just means stop where you are
            self.v.layer.position = (self.v.layer.presentationLayer() as! CALayer).position
            self.v.layer.removeAllAnimations()
        default: break
        }
    }
    
    @IBAction func doStart(sender:AnyObject?) {
        self.animate()
    }
    
    @IBAction func doStop(sender:AnyObject?) {
        self.cancel()
    }
    
    
}
