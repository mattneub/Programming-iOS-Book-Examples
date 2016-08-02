

import UIKit

func delay(_ delay:Double, closure:()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController: UIViewController {
    @IBOutlet var v: MyView!
    
    // MyView presents a facade where its "swing" property is view-animatable
    
    @IBAction func doButton(_ sender: AnyObject) {
        
        UIView.animate(withDuration:1) {
            self.v.swing = !self.v.swing // "animatable" Bool property
        }

        // can use a property animator here
//        let anim = UIViewPropertyAnimator(duration: 1, curve: .easeInOut) {
//            self.v.swing = !self.v.swing
//        }
//        anim.startAnimation()
        // use pause to prove it's an interruptible animation
//        delay(0.5) {
//            anim.pauseAnimation()
//        }
    }
    
    
}

class MyView : UIView {
    var swing : Bool = false {
        didSet {
            var p = self.center
            p.x = self.swing ? p.x + 100 : p.x - 100
            // this is the trick: perform actual view animation with zero duration
            // zero duration means we inherit the surrounding duration
            UIView.animate(withDuration:0) {
                self.center = p
            }
            // can use a property animator here too
            // but only if we generate it this way
//            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0, delay: 0, options: [], animations: {self.center = p})
        }
    }
}

