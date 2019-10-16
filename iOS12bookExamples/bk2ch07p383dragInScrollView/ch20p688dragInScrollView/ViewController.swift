

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

class ViewController : UIViewController {
    @IBOutlet var sv : UIScrollView!
    @IBOutlet var flag : UIImageView!
    @IBOutlet weak var map: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sv.contentSize = self.map.bounds.size
        self.sv.contentInsetAdjustmentBehavior = .never
    }
    
    @IBAction func dragging (_ p: UIPanGestureRecognizer) {
        let v = p.view!
        switch p.state {
        case .began, .changed:
            let delta = p.translation(in:v.superview!)
            v.center.x += delta.x
            v.center.y += delta.y
            p.setTranslation(.zero, in: v.superview)
//            if p.state == .began {break}
//            return; // uncomment to prevent autoscroll
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
