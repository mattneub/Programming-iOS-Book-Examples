

import UIKit


class ViewController  : UIViewController {
    @IBOutlet var v : UIView!
    @IBOutlet var longPresser : UILongPressGestureRecognizer!
    
    func longPress(lp:UILongPressGestureRecognizer) {
        switch lp.state {
        case .Began:
            let anim = CABasicAnimation(keyPath: "transform")
            anim.toValue = NSValue(CATransform3D:CATransform3DMakeScale(1.1, 1.1, 1))
            anim.fromValue = NSValue(CATransform3D:CATransform3DIdentity)
            anim.repeatCount = Float.infinity
            anim.autoreverses = true
            lp.view!.layer.addAnimation(anim, forKey:nil)
        case .Ended, .Cancelled:
            lp.view!.layer.removeAllAnimations()
        default: break
        }
    }
    
    func dragging(p : UIPanGestureRecognizer) {
        let vv = p.view!
        switch p.state {
        case .Began, .Changed:
            let delta = p.translationInView(vv.superview!)
            var c = vv.center
            c.x += delta.x; c.y += delta.y
            vv.center = c
            p.setTranslation(CGPointZero, inView: vv.superview)
        default: break
        }
    }
}

extension ViewController : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(g: UIGestureRecognizer) -> Bool {
        // g is the pan gesture recognizer
        switch self.longPresser.state {
        case .Possible, .Failed:
            return false
        default:
            return true
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
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
