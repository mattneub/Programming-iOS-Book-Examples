

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    @IBOutlet var v_horizontalPositionConstraint : NSLayoutConstraint!
    
    let which = 1

    @IBAction func doButton(_ sender: Any?) {
    
        switch which {
        case 1:
            UIView.animate(withDuration:1) {
                self.v.center.x += 100
            } // everything *looks* okay, but it isn't
            
        case 2:
            UIView.animate(withDuration:1, animations:{
                self.v.center.x += 100
                }, completion: {
                    _ in
                    // NB new in iOS 9 must call setNeedsLayout to get layout
                    self.v.superview!.setNeedsLayout()
                    self.v.superview!.layoutIfNeeded() // this is what will happen at layout time
                })
        case 3:
            // just proving that using a property animator 
            // doesn't magically solve this problem
            let anim = UIViewPropertyAnimator(duration: 1, curve: .linear) {
                self.v.center.x += 100
            }
            anim.addCompletion {
                _ in
                self.v.superview!.setNeedsLayout()
                self.v.superview!.layoutIfNeeded() // this is what will happen at layout time
            }
            anim.startAnimation()

            
        case 4:
            if let con = self.v_horizontalPositionConstraint {
                con.constant += 100
                UIView.animate(withDuration:1) {
                    self.v.superview!.layoutIfNeeded()
                }
            }
            
        case 5:
            // same thing with property animator
            if let con = self.v_horizontalPositionConstraint {
                con.constant += 100
                let anim = UIViewPropertyAnimator(duration: 1, curve: .linear) {
                    self.v.superview!.layoutIfNeeded()
                }
                anim.startAnimation()
            }

            

        case 6:
            // can animate a snapshot instead, but this leaves open the question...
            // ...of what will happen when the snapshot needs to be removed
            let snap = self.v.snapshotView(afterScreenUpdates:false)!
            snap.frame = self.v.frame
            self.v.superview!.addSubview(snap)
            self.v.isHidden = true
            UIView.animate(withDuration:1) {
                snap.center.x += 100
            }
            
        case 7:
            UIView.animate(withDuration:1, animations: {
                self.v.transform = CGAffineTransform(translationX: 100, y: 0)
            }, completion: { _ in
                self.v.superview!.setNeedsLayout()
                self.v.superview!.layoutIfNeeded() // prove that nothing bad happens
            })

            
        case 8:
            // don't try this one: it may appear to work but it causes a constraint conflict
            self.v.translatesAutoresizingMaskIntoConstraints = true
            UIView.animate(withDuration:1, animations:{
                self.v.center.x += 100
                }, completion: {
                    _ in
                    self.v.superview!.layoutIfNeeded() // ouch
            })



        default: break
        }
    }
}
