

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var v: UIView!
    var anim : UIViewPropertyAnimator!
    
    @IBAction func doStart(_ sender: Any) {
        self.anim = UIViewPropertyAnimator(duration: 4, timingParameters: UICubicTimingParameters())
        self.anim.addAnimations {
            UIView.animateKeyframes(withDuration: 0, delay: 0, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                    self.v.center.x += 100
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25) {
                    self.v.backgroundColor = .red
                }

            })
            
        }
        // if we don't set this, the view jumps when we continue the animation
        if #available(iOS 11.0, *) {
            self.anim.scrubsLinearly = false
        }
        self.anim.startAnimation()
    }
    
    @IBAction func doStop(_ sender: Any) {

        self.anim.pauseAnimation()
        self.anim.isReversed = true
        self.anim.continueAnimation(withTimingParameters: nil, durationFactor: 0)
    }
    
    
}

