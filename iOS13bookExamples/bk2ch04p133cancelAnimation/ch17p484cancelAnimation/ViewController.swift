import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    var pOrig : CGPoint!
    var pFinal : CGPoint!
    
    var useAnimator = true
    var anim : UIViewPropertyAnimator!
    
    func animate() {
        self.pOrig = self.v.center
        self.pFinal = self.v.center
        self.pFinal.x += 100
        UIView.animate(withDuration:4, animations: {
            self.v.center = self.pFinal
            }, completion: {
                _ in
                print("finished initial animation")
        })
    }
    
    func animate2() {
        self.anim = UIViewPropertyAnimator(duration: 4, timingParameters: UICubicTimingParameters())
        self.anim.addAnimations {
            self.v.center.x += 100
        }
        self.anim.addCompletion {
            finish in
            print(finish.rawValue)
        }
        self.anim.startAnimation()
    }
    
    let which = 3

    func cancel() {
        switch which {
        case 1:
            // simplest possible solution: just kill it dead
            self.v.layer.removeAllAnimations()
            /*
        case 2:
            // iOS 7 and before; no longer works in iOS 8
            let opts = UIViewAnimationOptions.beginFromCurrentState
            UIView.animate(withDuration:0.1, delay:0.1, options:opts,
                animations: {
                    var p = self.pFinal!
                    p.x += 1
                    self.v.center = p
                }, completion: {
                    _ in
                    self.v.center = self.pFinal
            })
 */
        case 2:
            // comment out the first two lines here to see what "additive" means
            // the new animation does not remove the original animation...
            // so the new animation just completes and the original proceeds as before
            // to prevent that, we have to intervene directly
            self.v.layer.position = self.v.layer.presentation()!.position
            self.v.layer.removeAllAnimations()
            UIView.animate(withDuration:0.1) {
                self.v.center = self.pFinal
            }
        case 3:
            // same thing except this time we decide to return to the original position
            // we will get there, but it will take us the rest of the original 4 seconds...
            // unless we intervene directly
            self.v.layer.position = self.v.layer.presentation()!.position
            self.v.layer.removeAllAnimations()
            UIView.animate(withDuration:0.1) {
                self.v.center = self.pOrig // need to have recorded original position
            }
        case 4:
            // cancel just means stop where you are
            self.v.layer.position = self.v.layer.presentation()!.position
            self.v.layer.removeAllAnimations()
        default: break
        }
    }
    
    func cancel2() {
        switch which {
        case 2: // hurry to end position
            print("hurry to end")
            self.anim.pauseAnimation()
            self.anim.continueAnimation(withTimingParameters: nil, durationFactor: 0.1)
        case 3: // hurry to start position
            print("hurry to start")
            // self.anim.scrubsLinearly = false // I regard the need to add this as a bug
            // ok the bug seems to be fixed
            self.anim.pauseAnimation()
            self.anim.isReversed = true
            self.anim.continueAnimation(withTimingParameters: nil, durationFactor: 0.1)
        case 4: // hurry to anywhere you like!
            print("hurry to somewhere else")
            self.anim.pauseAnimation()
            self.anim.addAnimations {
                self.v.center = CGPoint(-200,-200)
            }
            self.anim.continueAnimation(withTimingParameters: nil, durationFactor: 0.1)
        case 5:
            self.anim.stopAnimation(false) // means allow me to finish
            self.anim.finishAnimation(at: .current)
        default: break
        }
    }
    
    @IBAction func doStart(_ sender: Any?) {
        switch useAnimator {
        case false: self.animate()
        case true: self.animate2()
        }
        
    }
    
    @IBAction func doStop(_ sender: Any?) {
        switch useAnimator {
        case false: self.cancel()
        case true: self.cancel2()
        }
    }
    
    
}
