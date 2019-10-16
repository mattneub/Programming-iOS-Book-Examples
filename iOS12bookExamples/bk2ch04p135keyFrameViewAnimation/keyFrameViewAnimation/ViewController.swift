import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    
    var useAnimator = false
    
    @IBAction func doButton(_ sender: Any?) {
        switch useAnimator {
        case false:
            self.animate()
        case true:
            // prove that this overrides whatever the UIView.animate... says
            let anim = UIViewPropertyAnimator(duration: 8, curve: .easeInOut) {}
            anim.addAnimations {
                self.animate()
            }
            anim.startAnimation()
            return;
            delay(3) { // prove that we are pausable / reversible
                anim.pauseAnimation()
                anim.isReversed = true
                anim.startAnimation()
            }
        }
    }
    
    var which = 2
    func animate() {
        switch which {
        case 1:
            var p = self.v.center
            var opts : UIView.KeyframeAnimationOptions = .calculationModeLinear
            let opt2 : UIView.AnimationOptions = .curveLinear
            // opts.insert(opt2)
            opts.insert(UIView.KeyframeAnimationOptions(rawValue:opt2.rawValue))
            let dur = 0.25
            var start = 0.0
            let dx : CGFloat = 100
            let dy : CGFloat = 50
            var dir : CGFloat = 1
            UIView.animateKeyframes(withDuration:4,
                                    delay: 0,
                                    options: opts, // comment in or out
                animations: {
                    // self.v.alpha = 0
                    UIView.addKeyframe(withRelativeStartTime:start,
                                       relativeDuration: dur) {
                                        p.x += dx*dir; p.y += dy
                                        self.v.center = p
                    }
                    start += dur; dir *= -1
                    UIView.addKeyframe(withRelativeStartTime:start,
                                       relativeDuration: dur) {
                                        p.x += dx*dir; p.y += dy
                                        self.v.center = p
                    }
                    start += dur; dir *= -1
                    UIView.addKeyframe(withRelativeStartTime:start,
                                       relativeDuration: dur) {
                                        p.x += dx*dir; p.y += dy
                                        self.v.center = p
                    }
                    start += dur; dir *= -1
                    UIView.addKeyframe(withRelativeStartTime:start,
                                       relativeDuration: dur) {
                                        p.x += dx*dir; p.y += dy
                                        self.v.center = p
                    }
            })
        case 2:
            var p = self.v.center
            var opts : UIView.KeyframeAnimationOptions = .calculationModeCubic
            let opt2 : UIView.AnimationOptions = .curveLinear
            // opts.insert(opt2)
            opts.insert(UIView.KeyframeAnimationOptions(rawValue:opt2.rawValue))
            let durs = [0.5, 0.3, 0.15, 0.05]
            let starts = [0.0, 0.5, 0.8, 0.95]
            let dx : CGFloat = 100
            let dy : CGFloat = 50
            var dir : CGFloat = 1
            var ix = 0
            UIView.animateKeyframes(withDuration:2,
                                    delay: 0,
                                    options: opts, // comment in or out
                animations: {
                    // self.v.alpha = 0
                    UIView.addKeyframe(withRelativeStartTime:starts[ix],
                                       relativeDuration: durs[ix]) {
                                        p.x += dx*dir; p.y += dy
                                        self.v.center = p
                    }
                    dir *= -1; ix += 1
                    UIView.addKeyframe(withRelativeStartTime:starts[ix],
                                       relativeDuration: durs[ix]) {
                                        p.x += dx*dir; p.y += dy
                                        self.v.center = p
                    }
                    dir *= -1; ix += 1
                    UIView.addKeyframe(withRelativeStartTime:starts[ix],
                                       relativeDuration: durs[ix]) {
                                        p.x += dx*dir; p.y += dy
                                        self.v.center = p
                    }
                    dir *= -1; ix += 1
                    UIView.addKeyframe(withRelativeStartTime:starts[ix],
                                       relativeDuration: durs[ix]) {
                                        p.x += dx*dir; p.y += dy
                                        self.v.center = p
                    }
            })

        default : break
        }
        
    }
    
}
