

import UIKit

class ViewController : UIViewController {
    
    @IBOutlet var iv : UIImageView!
    @IBOutlet var v : MyView!
    @IBOutlet var outer : UIView!
    @IBOutlet var inner : UIView!
    
    @IBAction func doButton(sender : AnyObject?) {
        self.animate()
    }
    
    func animate() {
        let opts : UIViewAnimationOptions = .TransitionFlipFromLeft
        UIView.transitionWithView(self.iv, duration: 0.8, options: opts,
            animations: {
                self.iv.image = UIImage(named:"Smiley")
            }, completion: nil)
        
        // ======
        
        self.v.reverse = !self.v.reverse
        UIView.transitionWithView(self.v, duration: 1, options: opts,
            animations: {
                self.v.setNeedsDisplay()
            }, completion: nil)
        
        // ======
        
        let opts2 : UIViewAnimationOptions = .TransitionFlipFromLeft | .AllowAnimatedContent
        UIView.transitionWithView(self.outer, duration: 1, options: opts2,
            animations: {
                var f = self.inner.frame
                f.size.width = self.outer.frame.width
                f.origin.x = 0
                self.inner.frame = f
            }, completion: nil)
        
    }
    
}
