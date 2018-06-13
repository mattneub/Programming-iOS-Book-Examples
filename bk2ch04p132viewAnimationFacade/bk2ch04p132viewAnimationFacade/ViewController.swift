

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController: UIViewController {
    @IBOutlet var v: MyView!
    
    // MyView presents a facade where its "swing" property is view-animatable
    
    @IBAction func doButton(_ sender: Any) {
        
//        UIView.animate(withDuration:1) {
//            self.v.swing.toggle() // "animatable" Bool property
//        }

        // can use a property animator here
        let anim = UIViewPropertyAnimator(duration: 1, curve: .easeInOut) {
            self.v.swing.toggle()
        }
        anim.startAnimation()
        return; // uncomment to test interruption
        delay(0.5) {
            anim.pauseAnimation()  // to prove it's an interruptible animation
            // but in iOS 11 we then crash because you can't release a paused animator...
            // ... so I'd better stop it too
            anim.stopAnimation(true)
        }
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

