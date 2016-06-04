

import UIKit

class ViewController : UIViewController {
    
    @IBOutlet var iv : UIImageView!
    @IBOutlet var v : MyView!
    @IBOutlet var outer : UIView!
    @IBOutlet var inner : UIView!
    
    @IBAction func doButton(_ sender: AnyObject?) {
        self.animate()
    }
    
    func animate() {
        let opts : UIViewAnimationOptions = .transitionFlipFromLeft
        UIView.transition(with:self.iv, duration: 0.8, options: opts,
            animations: {
                self.iv.image = UIImage(named:"Smiley")
            })
        
        // ======
        
        self.v.reverse = !self.v.reverse
        UIView.transition(with:self.v, duration: 1, options: opts,
            animations: {
                self.v.setNeedsDisplay()
            })
        
        // ======
        
        let opts2 : UIViewAnimationOptions = [.transitionFlipFromLeft, .allowAnimatedContent]
        UIView.transition(with:self.outer, duration: 1, options: opts2,
            animations: {
                var f = self.inner.frame
                f.size.width = self.outer.frame.width
                f.origin.x = 0
                self.inner.frame = f
            })
        
    }
    
}
