

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

extension UIView {
    class func animate(times:Int,
        duration dur: TimeInterval,
        delay del: TimeInterval,
        options opts: UIView.AnimationOptions,
        animations anim: @escaping () -> Void,
        completion comp: ((Bool) -> Void)?) {
            func helper(_ t:Int,
                _ dur: TimeInterval,
                _ del: TimeInterval,
                _ opt: UIView.AnimationOptions,
                _ anim: @escaping () -> Void,
                _ com: ((Bool) -> Void)?) {
                    UIView.animate(withDuration: dur,
                        delay: del, options: opt,
                        animations: anim, completion: {
                            done in
                            if com != nil {
                                com!(done)
                            }
                            if t > 0 {
                                delay(0) {
                                    helper(t-1, dur, del, opt, anim, com)
                                }
                            }
                    })
            }
            helper(times-1, dur, del, opts, anim, comp)
    }

}

class ViewController: UIViewController {
    @IBOutlet weak var v: UIView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let which = 14
        
        delay(3) {
            print(0)
            print(self.v.center.y)
            switch which {
            case 0:
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(1)
                self.v.backgroundColor = .red
                UIView.commitAnimations()
            case 1:
                UIView.animate(withDuration:2) {
                    self.v.backgroundColor = .red
                }
            case 2:
                let anim = UIViewPropertyAnimator(duration: 1, curve: .linear) {
                    print("starting the animation (not really)")
                    self.v.backgroundColor = .red
                    print("ending the animation (not really)")
                }
                anim.startAnimation() // retains the animator, don't worry
                print("starting to sleep")
                usleep(10000000)
                print("finished sleeping")
                // despite the name, animation does not start until your code finishes
                // so it is true view animation managed on the animation server as before
                // however, other code in the animations function runs as soon as you call...
                // startAnimation, as the logging here shows
            case 3:
                var anim = UIViewPropertyAnimator(duration: 1, curve: .linear) {
                    self.v.backgroundColor = .red
                    self.v.center.y += 100
                }
                // states are inactive, active, stopped
                var ob : Any? = anim.observe(\.state) {
                    _,_ in
                    print("state", anim.state.rawValue, "running", anim.isRunning)
                }
                var ob2 : Any? = anim.observe(\.isRunning) {
                    _,_ in
                    print("running", anim.isRunning, "state", anim.state.rawValue)
                    if !anim.isRunning && anim.pausesOnCompletion {
                        print("paused on completion")
                        // paused on completion; must stop before release
                        // it is a runtime error to release a paused animator
                        anim.stopAnimation(false)
                        // as soon as you stop, the animations are removed from the layer
                        print(self.v.layer.animationKeys() as Any)
                        // if you said stopAnimation(false), you must say finishAnimation
                        // otherwise it's a runtime error
                        // but if you said stopAnimation(true), doesn't matter
                        anim.finishAnimation(at: .end)
                        // the combination stopAnimation(false) -> finishAnimation...
                        // ...runs completion handlers. No other combination does.
                    }
                }
                // uncomment next line to see new iOS 11 feature
                anim.pausesOnCompletion = true
                print("state before", anim.state.rawValue, "running", anim.isRunning)
                anim.addCompletion {_ in print("completion handler")}
                anim.startAnimation() // logs immediately as we go from not running to running
                print("linearly", anim.scrubsLinearly) // logs second
                print(self.v.layer.animationKeys() as Any)
                delay(2) {
                    ob = nil // heh heh, just keeping the observer alive
                    ob2 = nil // heh heh, just keeping the other observer alive
                    print(anim) // heh heh, just keeping the animator alive
                }
                // in both cases, goes
//                state 1 running false
//                running true state 1
                // ("linearly true")
//                running false state 1
                // ("paused on completion")
//                state 0 running false
            case 4:
                var anim = UIViewPropertyAnimator(duration: 1, curve: .linear) {
                    self.v.backgroundColor = .red
                    self.v.center.y += 100
                }
                var ob : Any? = anim.observe(\.isRunning) {
                    _,_ in
                    if !anim.isRunning && anim.pausesOnCompletion {
                        // so what else can we do when paused on completion?
                        // well, we could reverse
                        anim.isReversed = true
                        // must turn off pause on completion...
                        // ... as it is a crime to release the animator while paused
                        anim.pausesOnCompletion = false
                        // note use of nil and 0 here
                        anim.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                    }
                }
                anim.pausesOnCompletion = true
                anim.addCompletion {_ in
                    print("hey")
                }
                anim.addCompletion {_ in
                    print("ho")
                }
                anim.startAnimation() // logs immediately as we go from not running to running
                delay(2) {
                    ob = nil // heh heh, just keeping the observer alive
                }

            case 5:
                let anim = UIViewPropertyAnimator(duration: 1, timingParameters: UICubicTimingParameters(animationCurve:.linear))
                anim.addAnimations {
                    self.v.backgroundColor = .red
                }
                anim.addAnimations {
                    self.v.center.y += 100
                }
                anim.startAnimation()
            case 6:
                self.v.layer.contents = UIImage(named:"smileySquareIcon")!.cgImage
                let v2 = UIView()
                v2.backgroundColor = .black
                v2.alpha = 0
                v2.frame = self.v.frame
                self.v.superview!.addSubview(v2)
                let anim = UIViewPropertyAnimator(duration: 2, curve: .linear) {
                    self.v.alpha = 0
                    v2.alpha = 1
                }
                anim.addCompletion { _ in
                    print("removing")
                    self.v.removeFromSuperview()
                }
                anim.addCompletion {
                    _ in print("one ringy dingy") // proving that multiple completions work
                }
                anim.startAnimation(afterDelay:3)
            case 7:
                UIView.perform(.delete, on: [self.v], animations: nil) {
                    _ in print(self.v.superview as Any)
                }
            case 8:
                let anim = UIViewPropertyAnimator(duration: 1, curve: .linear) {
                    self.v.backgroundColor = .red
                    UIView.performWithoutAnimation {
                        self.v.center.y += 100
                    }
                }
                anim.startAnimation()
            case 9:
                func report(_ ix:Int) {
                    // at last, the presentation layer comes to you as a CALayer (Optional)
                    let pres = self.v.layer.presentation()!.position.y
                    let model = self.v.center.y
                    print("step \(ix): presentation \(pres), model \(model)")
                }
                let anim = UIViewPropertyAnimator(duration: 2, curve: .linear) {
                    report(2)
                    self.v.center.y += 100
                    report(3)
                }
                anim.addCompletion {
                    _ in
                    report(4)
                }
                self.v.center.y += 300
                report(1)
                anim.startAnimation()
            case 10:
                let anim = UIViewPropertyAnimator(duration: 0, curve: .linear) {
                    self.v.center.y += 100
                    self.v.center.y += 300
                }
                anim.addCompletion {_ in print(self.v.center.y)}
                anim.startAnimation()
                print(anim.duration) // 0 turns out to mean 0.2
            case 11:
                let anim = UIViewPropertyAnimator(duration: 1, curve: .linear) {
                    print("start2")
                    self.v.center.y += 300
                }
                anim.startAnimation(afterDelay:2)
                print(anim.delay)
                print(anim.isInterruptible)
                print(anim.isUserInteractionEnabled)
                print(anim.isManualHitTestingEnabled)
                print("start")
            case 12:
                let opts : UIView.AnimationOptions = .autoreverse
                let xorig = self.v.center.x
                UIView.animate(withDuration:1, delay: 0, options: opts, animations: {
                    self.v.center.x += 100
                    }, completion: {
                        _ in
                        self.v.center.x = xorig
                })
                // can't figure out how to reproduce that using property animator
            case 13:
                let opts : UIView.AnimationOptions = .autoreverse
                let xorig = self.v.center.x
                UIView.animate(withDuration:1, delay: 0, options: opts, animations: {
                    UIView.setAnimationRepeatCount(3) // *
                    self.v.center.x += 100
                    }, completion: {
                        _ in
                        self.v.center.x = xorig
                })
            case 14:
                // something like an autoreversing repeating animation
                // made with a property animator
                var right = true
                var count = 6
                func goOneWay() {
                    let anim = UIViewPropertyAnimator(duration: 1, curve: .easeInOut)
                    anim.addAnimations {
                        if right {
                            self.v.center.x += 100
                        } else {
                            self.v.center.x -= 100
                        }
                    }
                    anim.addCompletion { _ in
                        count -= 1
                        guard count > 0 else { return }
                        right.toggle()
                        goOneWay()
                    }
                    anim.startAnimation()
                }
                goOneWay()
            case 15:
                print(self.v.center)
                let anim = UIViewPropertyAnimator(duration: 2, curve: .easeInOut) {
                    self.v.center.y += 100
                }
                anim.addAnimations({
                    self.v.center.x += 100
                }, delayFactor: 0.5)
                anim.addCompletion {
                    _ in print(self.v.center)
                }
                anim.startAnimation()
            case 16:
                print(self.v.center)
                let yorig = self.v.center.y
                let anim = UIViewPropertyAnimator(duration: 2, curve: .easeInOut) {
                    self.v.center.y += 100
                }
                anim.addAnimations({
                    self.v.center.y = yorig
                    }, delayFactor: 0.5)
                anim.addCompletion {
                    _ in print(self.v.center)
                }
                anim.startAnimation()
                /*
            case 9:
                self.animate(count:3)
            case 10:
                let opts = UIViewAnimationOptions.autoreverse
                let xorig = self.v.center.x
                UIView.animate(times:3, duration:1, delay:0, options:opts, animations:{
                    self.v.center.x += 100
                    }, completion:{
                        _ in
                        self.v.center.x = xorig
                })
            case 11:
                UIView.animate(withDuration:1) {
                    self.v.center.x += 100
                }
                // let opts = UIViewAnimationOptions.beginFromCurrentState
                UIView.animate(withDuration:1) {
                        self.v.center.y += 100
                }
            case 12:
                UIView.animate(withDuration:2, animations: {
                    self.v.center.x += 100
                })
                delay(1) {
                    // let opts = UIViewAnimationOptions.beginFromCurrentState
                    UIView.animate(withDuration:1, delay: 0, options: [],
                        animations: {
                            self.v.center.y += 100
                        })
                }
 */
            default:break
            }
        }
    }
    
    let whichAnimateWay = 2 // 1 or 2
    
    func animate(count:Int) {
        switch whichAnimateWay {
        case 1:
            let opts = UIView.AnimationOptions.autoreverse
            let xorig = self.v.center.x
            UIView.animate(withDuration:1, delay: 0, options: opts, animations: {
                UIView.setAnimationRepeatCount(Float(count)) // I really don't like this
                self.v.center.x += 100
                }, completion: {
                    _ in
                    self.v.center.x = xorig
            })
        case 2:
            let opts = UIView.AnimationOptions.autoreverse
            let xorig = self.v.center.x
            UIView.animate(withDuration:1, delay: 0, options: opts, animations: {
                self.v.center.x += 100
                }, completion: {
                    _ in
                    self.v.center.x = xorig
                    if count > 1 {
                        delay(0) {
                            self.animate(count:count-1)
                        }
                    }
            })
        default: break
        }
    }
    
}

