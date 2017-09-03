

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

class ViewController : UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet var sv : UIScrollView!
    @IBOutlet var flag : UIImageView!
    @IBOutlet weak var map: UIImageView!
    @IBOutlet weak var swipe: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.flag.translatesAutoresizingMaskIntoConstraints = true // tricky-wicky
        
        self.sv.panGestureRecognizer.require(toFail:self.swipe) // *
        
        let iv = UIImageView(image:UIImage(named:"smiley.png"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        self.sv.addSubview(iv)
        // let sup = self.sv.superview!
        // new in iOS 11, we have frame layout guide to pin to
        let svflg = self.sv.frameLayoutGuide
        NSLayoutConstraint.activate([
            iv.rightAnchor.constraint(equalTo:svflg.rightAnchor, constant: -5),
            iv.topAnchor.constraint(equalTo:svflg.topAnchor, constant: 25)
            ])
        
//        delay(2) {
//            print(self.view.subviews)
//        }
    }
    
    // delegate of flag's pan gesture recognizer
    
    // perhaps this was a bug? I can't reproduce the problem any more

//    func gestureRecognizer(g: UIGestureRecognizer!, shouldBeRequiredToFailByGestureRecognizer og: UIGestureRecognizer!) -> Bool {
//        println(g)
//        println(og)
//        return true // keep our flag gesture recognizer first
//        // trying to avoid weird behavior where sometimes pan gesture fails
//    }
    
    @IBAction func swiped (_ g: UISwipeGestureRecognizer) {
        let sv = self.sv!
        let p = sv.contentOffset
        self.flag.frame.origin = p
        self.flag.frame.origin.x -= self.flag.bounds.width
        self.flag.isHidden = false
        
        UIView.animate(withDuration:0.25) {
            self.flag.frame.origin.x = p.x
            // thanks for the flag, now stop operating altogether
            g.isEnabled = false
        }
    }
    
    @IBAction func dragging (_  p: UIPanGestureRecognizer) {
        let v = p.view!
        switch p.state {
        case .began, .changed:
            let delta = p.translation(in:v.superview!)
            v.center.x += delta.x
            v.center.y += delta.y
            p.setTranslation(.zero, in: v.superview)
            // autoscroll
            let sv = self.sv!
            let loc = p.location(in:sv)
            let f = sv.bounds
            var off = sv.contentOffset
            let sz = sv.contentSize
            var c = v.center
            // to the right
            if loc.x > f.maxX - 30 {
                let margin = sz.width - sv.bounds.maxX
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
            if loc.y > f.maxY - 30 {
                let margin = sz.height - sv.bounds.maxY
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
    
    func keepDragging (_ p: UIPanGestureRecognizer) {
        // the delay here, combined with the change in offset, determines the speed of autoscrolling
        let del = 0.1
        delay(del) {
            self.dragging(p)
        }
    }
    
}
