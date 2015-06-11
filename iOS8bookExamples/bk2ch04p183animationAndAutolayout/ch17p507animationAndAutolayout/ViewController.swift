

import UIKit


class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    @IBOutlet var v_horizontalPositionConstraint : NSLayoutConstraint!
    
    @IBAction func doButton(sender:AnyObject?) {
    
        let which = 1
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
                    self.v.layoutIfNeeded() // this is what will happen at layout time
                })

        case 3:
            let con = self.v_horizontalPositionConstraint
            con.constant += 100
            UIView.animateWithDuration(1, animations:{
                self.v.layoutIfNeeded()
                }, completion: {
                    _ in
                    // self.v.layoutIfNeeded() // uncomment to prove there's now no problem
                })
            
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
                    self.v.hidden = false
                    snap.removeFromSuperview()
                })

        case 7:
            let snap = self.v.snapshotViewAfterScreenUpdates(false)
            snap.frame = self.v.frame
            self.v.superview!.addSubview(snap)
            self.v.hidden = true
            UIView.animateWithDuration(1, animations:{
                snap.center.x += 100
                })


        default: break
        }
    }
}
