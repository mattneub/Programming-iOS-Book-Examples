

import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class ViewController : UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet var sv : UIScrollView!
    @IBOutlet var flag : UIImageView!
    @IBOutlet weak var map: UIImageView!
    @IBOutlet weak var swipe: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.flag.translatesAutoresizingMaskIntoConstraints = true // tricky-wicky
        
        self.sv.panGestureRecognizer.requireGestureRecognizerToFail(self.swipe) // *
        
        let iv = UIImageView(image:UIImage(named:"smiley.png"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        self.sv.addSubview(iv)
        let sup = self.sv.superview!
        NSLayoutConstraint.activateConstraints([
            iv.rightAnchor.constraintEqualToAnchor(sup.rightAnchor, constant: -5),
            iv.topAnchor.constraintEqualToAnchor(sup.topAnchor, constant: 25)
            ])
    }
    
    // delegate of flag's pan gesture recognizer
    
    // perhaps this was a bug? I can't reproduce the problem any more

//    func gestureRecognizer(g: UIGestureRecognizer!, shouldBeRequiredToFailByGestureRecognizer og: UIGestureRecognizer!) -> Bool {
//        println(g)
//        println(og)
//        return true // keep our flag gesture recognizer first
//        // trying to avoid weird behavior where sometimes pan gesture fails
//    }
    
    @IBAction func swiped (g: UISwipeGestureRecognizer) {
        let sv = self.sv
        let p = sv.contentOffset
        self.flag.frame.origin = p
        self.flag.frame.origin.x -= self.flag.bounds.size.width
        self.flag.hidden = false
        
        UIView.animateWithDuration(0.25, animations:{
            self.flag.frame.origin.x = p.x
            // thanks for the flag, now stop operating altogether
            g.enabled = false
            })
    }
    
    @IBAction func dragging (p : UIPanGestureRecognizer) {
        let v = p.view!
        switch p.state {
        case .Began, .Changed:
            let delta = p.translationInView(v.superview!)
            v.center.x += delta.x
            v.center.y += delta.y
            p.setTranslation(CGPointZero, inView: v.superview)
            if p.state == .Changed {fallthrough} // comment out to prevent autoscroll
        case .Changed:
            // autoscroll
            let sv = self.sv
            let loc = p.locationInView(sv)
            let f = sv.bounds
            var off = sv.contentOffset
            let sz = sv.contentSize
            var c = v.center
            // to the right
            if loc.x > CGRectGetMaxX(f) - 30 {
                let margin = sz.width - CGRectGetMaxX(sv.bounds)
                if margin > 6 {
                    off.x += 5
                    sv.contentOffset = off
                    c.x += 5
                    v.center = c
                    self.keepDragging(p)
                }
            }
            // to the left
            if loc.x < f.origin.x + 30 {
                let margin = off.x
                if margin > 6 {
                    off.x -= 5
                    sv.contentOffset = off
                    c.x -= 5
                    v.center = c
                    self.keepDragging(p)
                }
            }
            // to the bottom
            if loc.y > CGRectGetMaxY(f) - 30 {
                let margin = sz.height - CGRectGetMaxY(sv.bounds)
                if margin > 6 {
                    off.y += 5
                    sv.contentOffset = off
                    c.y += 5
                    v.center = c
                    self.keepDragging(p)
                }
            }
            // to the top
            if loc.y < f.origin.y + 30 {
                let margin = off.y
                if margin > 6 {
                    off.y -= 5
                    sv.contentOffset = off
                    c.y -= 5
                    v.center = c
                    self.keepDragging(p)
                }
            }

        default: break
        }
    }
    
    func keepDragging (p : UIPanGestureRecognizer) {
        // the delay here, combined with the change in offset, determines the speed of autoscrolling
        let del = 0.1
        delay(del) {
            self.dragging(p)
        }
    }
    
}
