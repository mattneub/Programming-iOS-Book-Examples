

import UIKit


class ViewController  : UIViewController {
    @IBOutlet var v : UIView!
    var longPresser : UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let p = UIPanGestureRecognizer(target:self, action:#selector(dragging))
        let lp = UILongPressGestureRecognizer(target:self, action:#selector(longPress))
        lp.numberOfTapsRequired = 1
        self.v.addGestureRecognizer(p)
        self.v.addGestureRecognizer(lp)
        self.longPresser = lp
        p.delegate = self
    }
    
    @objc func longPress(_ lp:UILongPressGestureRecognizer) {
        switch lp.state {
        case .began:
            let anim = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
            anim.toValue = CATransform3DMakeScale(1.1, 1.1, 1)
            anim.fromValue = CATransform3DIdentity
            anim.repeatCount = .greatestFiniteMagnitude
            anim.autoreverses = true
            lp.view!.layer.add(anim, forKey:nil)
        case .ended, .cancelled:
            lp.view!.layer.removeAllAnimations()
        default: break
        }
    }
    
    @objc func dragging(_ p : UIPanGestureRecognizer) {
        let vv = p.view!
        switch p.state {
        case .began, .changed:
            let delta = p.translation(in:vv.superview!)
            var c = vv.center
            c.x += delta.x; c.y += delta.y
            vv.center = c
            p.setTranslation(.zero, in: vv.superview)
        default: break
        }
    }
}

extension ViewController : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ g: UIGestureRecognizer) -> Bool {
        switch self.longPresser.state {
        case .possible, .failed:
            return false
        default:
            return true
        }
    }
    
    func gestureRecognizer(_ g: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith
        g2: UIGestureRecognizer) -> Bool {
            print("sim")
            return true
    }
    
    /*
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    println("=== should\n\(gestureRecognizer)\n\(otherGestureRecognizer)")
    return false
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    println("=== should be\n\(gestureRecognizer)\n\(otherGestureRecognizer)")
    return false
    }
    
    */
    
}
