
import UIKit

class ViewController : UIViewController {
    @IBAction func doButton(sender:AnyObject?) {
        print("button tap!")
    }
    
    @IBAction func tapped(g:UITapGestureRecognizer) {
        let p = g.locationOfTouch(0, inView: g.view)
        let v = g.view!.hitTest(p, withEvent: nil)
        if let v = v as? UIImageView {
            UIView.animateWithDuration(0.2, delay: 0,
                options: .Autoreverse,
                animations: {
                    v.transform = CGAffineTransformMakeScale(1.1, 1.1)
                }, completion: {
                    _ in
                    v.transform = CGAffineTransformIdentity
                })
        }
    }
}



class MyView : UIView {
    
    // the button is a subview of this view... try to tap it
    
    // normally, you can't touch a subview's region outside its superview
    // but you can *see* a subview outside its superview if the superview doesn't clip to bounds,
    // so why shouldn't you be able to touch it?
    // this hitTest override makes it possible
    // try the example with hitTest commented out and with it restored to see the difference

    override func hitTest(point: CGPoint, withEvent e: UIEvent?) -> UIView? {
        if let result = super.hitTest(point, withEvent:e) {
            return result
        }
        for sub in self.subviews.reverse() {
            let pt = self.convertPoint(point, toView:sub)
            if let result = sub.hitTest(pt, withEvent:e) {
                return result
            }
        }
        return nil
    }
}
