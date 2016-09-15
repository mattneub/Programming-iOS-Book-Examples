

import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}


class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    @IBOutlet var v_horizontalPositionConstraint : NSLayoutConstraint!
    
    let which = 8

    @IBAction func doButton(sender:AnyObject?) {
    
        switch which {
        case 1:
            UIView.animateWithDuration(1, animations:{
                self.v.center.x += 100
                }) // everything *looks* okay, but it isn't
            
        case 2:
            UIView.animateWithDuration(1, animations:{
                self.v.center.x += 100
                }, completion: {
                    _ in
                    // NB new in iOS 9 must call setNeedsLayout to get layout
                    self.v.superview!.setNeedsLayout()
                    self.v.superview!.layoutIfNeeded() // this is what will happen at layout time
                })

        case 3:
            let con = self.v_horizontalPositionConstraint
            con.constant += 100
            UIView.animateWithDuration(1, animations:{
                self.v.superview!.layoutIfNeeded()
                }, completion: nil)
            
        case 4:
            // this works fine in iOS 8! does not trigger spurious layout
            UIView.animateWithDuration(0.3, delay: 0, options: .Autoreverse, animations: {
                self.v.transform = CGAffineTransformMakeScale(1.1, 1.1)
                }, completion: {
                    _ in
                    self.v.transform = CGAffineTransformIdentity
                })

        case 5:
            // this works in iOS 7 as well; layer animation does not trigger spurious layout there
            let ba = CABasicAnimation(keyPath:"transform")
            ba.autoreverses = true
            ba.duration = 0.3
            ba.toValue = NSValue(CATransform3D:CATransform3DMakeScale(1.1, 1.1, 1))
            self.v.layer.addAnimation(ba, forKey:nil)
            
        case 6:
            // general solution to all such problems: animate a temporary snapshot instead!
            let snap = self.v.snapshotViewAfterScreenUpdates(false)
            snap.frame = self.v.frame
            self.v.superview!.addSubview(snap)
            self.v.hidden = true
            UIView.animateWithDuration(0.3, delay:0, options:.Autoreverse,
                animations:{
                    snap.transform = CGAffineTransformMakeScale(1.1, 1.1)
                }, completion: {
                    _ in
                    // sometimes there is a flash; I may be able to prevent it with a delay
                    //delay(0) {
                        self.v.hidden = false
                        snap.removeFromSuperview()
                    //}
                })

        case 7:
            let snap = self.v.snapshotViewAfterScreenUpdates(false)
            snap.frame = self.v.frame
            self.v.superview!.addSubview(snap)
            self.v.hidden = true
            UIView.animateWithDuration(1, animations:{
                snap.center.x += 100
                })
            
        case 8:
            // don't try this one: it may appear to work but it causes a constraint conflict
            self.v.translatesAutoresizingMaskIntoConstraints = true
            UIView.animateWithDuration(1, animations:{
                self.v.center.x += 100
                }, completion: {
                    _ in
                    self.v.superview!.layoutIfNeeded() // ouch
            })



        default: break
        }
    }
}
