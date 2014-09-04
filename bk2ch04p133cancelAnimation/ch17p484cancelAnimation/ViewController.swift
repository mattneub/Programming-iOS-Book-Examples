import UIKit


class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    var pOrig : CGPoint!
    
    func animate() {
        self.pOrig = self.v.center
        UIView.animateWithDuration(4, animations: {
            self.v.center.x += 100
            }, completion: {
                _ in
                println("finished initial animation")
        })
    }
    
    /*
    func cancel() {
        // old code:
        UIView.animateWithDuration(0.1, delay:0.1, options:.BeginFromCurrentState,
            animations: {
            var p = self.pFinal! // (assuming we recorded this beforehand)
            p.x += 1
            self.v.center = p
            }, completion: {
                _ in
                self.v.center = self.pFinal
            })
        // but in iOS 8 that no longer works...
        // ...because starting a new animation is additive
    }
*/
    
    func cancel() {
        let which = 1
        switch which {
        case 1:
            // comment out the first two lines here to see what "additive" means
            // the new animation does not remove the original animation...
            // so the new animation just completes and the original proceeds as before
            // to prevent that, we have to intervene directly
            let pFinal = self.v.center // it is already there
            self.v.layer.position = self.v.layer.presentationLayer().position
            self.v.layer.removeAllAnimations()
            UIView.animateWithDuration(0.1, animations: {
                self.v.center = pFinal
                }, completion: {
                    _ in
                    println ("finished second animation")
                })
        case 2:
            // same thing except this time we decide to return to the original position
            // we will get there, but it will take us the rest of the original 4 seconds...
            // unless we intervene directly
            self.v.layer.position = self.v.layer.presentationLayer().position
            self.v.layer.removeAllAnimations()
            UIView.animateWithDuration(0.1, animations: {
                self.v.center = self.pOrig // need to have recorded original position
                }, completion: {
                    _ in
                    println ("finished second animation")
                })
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
