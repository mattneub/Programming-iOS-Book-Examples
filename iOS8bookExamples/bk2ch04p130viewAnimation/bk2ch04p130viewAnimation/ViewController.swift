

import UIKit
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

extension UIView {
    class func animateWithTimes(times:Int, duration: NSTimeInterval,
        delay: NSTimeInterval, options: UIViewAnimationOptions,
        animations: () -> Void, completion: ((Bool) -> Void)?) {
            self.animHelper(
                times-1, duration, delay, options, animations, completion)
    }

    class func animHelper(t:Int, _ dur: NSTimeInterval, _ del: NSTimeInterval,
        _ opt: UIViewAnimationOptions,
        _ anim: () -> Void, _ com: ((Bool) -> Void)?) {
            UIView.animateWithDuration(dur, delay: del, options: opt,
                animations: anim, completion: {
                    done in
                    if com != nil {
                        com!(done)
                    }
                    if t > 0 {
                        self.animHelper(t-1, dur, del, opt, anim, com)
                    }
            })
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var v: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let which = 1
        
        delay(3) {
            println(0)
            println(self.v.center.y)
            switch which {
            case 1:
                UIView.animateWithDuration(0.4, animations: {
                    self.v.backgroundColor = UIColor.redColor()
                })
            case 2:
                UIView.animateWithDuration(0.4, animations: {
                    self.v.backgroundColor = UIColor.redColor()
                    self.v.center.y += 100
                })
            case 3:
                let v2 = UIView()
                v2.backgroundColor = UIColor.blackColor()
                v2.alpha = 0
                v2.frame = self.v.frame
                self.v.superview!.addSubview(v2)
                UIView.animateWithDuration(0.4, animations: {
                    self.v.alpha = 0
                    v2.alpha = 1
                    }, completion: {
                        _ in
                        self.v.removeFromSuperview()
                })
            case 4:
                UIView.animateWithDuration(0.4, animations: {
                    self.v.backgroundColor = UIColor.redColor()
                    UIView.performWithoutAnimation {
                        self.v.center.y += 100
                    }
                })
            case 5:
                UIView.animateWithDuration(2, animations: {
                    println(2)
                    println(self.v.center.y)
                    self.v.center.y = 100
                    println(3)
                    println(self.v.center.y)
                    }, completion: {
                        _ in
                        println(4)
                        println(self.v.center.y)
                })
                self.v.center.y = 300
                println(1)
                println(self.v.center.y)
            case 6:
                UIView.animateWithDuration(2, animations: {
                    self.v.center.y = 100
                    self.v.center.y = 300
                })
            case 7:
                let opts = UIViewAnimationOptions.Autoreverse
                let xorig = self.v.center.x
                UIView.animateWithDuration(1, delay: 0, options: opts, animations: {
                    self.v.center.x += 100
                    }, completion: {
                        _ in
                        self.v.center.x = xorig
                })
            case 8:
                self.animate(3)
            case 9:
                let opts = UIViewAnimationOptions.Autoreverse
                let xorig = self.v.center.x
                UIView.animateWithTimes(3, duration:1, delay:0, options:opts, animations:{
                    self.v.center.x += 100
                    }, completion:{
                        _ in
                        self.v.center.x = xorig
                })
            case 10:
                UIView.animateWithDuration(1, animations: {
                    self.v.center.x += 100
                })
                let opts = UIViewAnimationOptions.BeginFromCurrentState
                UIView.animateWithDuration(1, delay: 0, options: nil,
                    animations: {
                        self.v.center.y += 100
                    }, completion: nil)
            case 11:
                UIView.animateWithDuration(2, animations: {
                    self.v.center.x += 100
                })
                delay(1) {
                    let opts = UIViewAnimationOptions.BeginFromCurrentState
                    UIView.animateWithDuration(1, delay: 0, options: opts,
                        animations: {
                            self.v.center.y += 100
                        }, completion: nil)
                }
            default:break
            }
        }
    }
    
    let whichAnimateWay = 2 // 1 or 2
    
    func animate(count:Int) {
        switch whichAnimateWay {
        case 1:
            let opts = UIViewAnimationOptions.Autoreverse
            let xorig = self.v.center.x
            UIView.animateWithDuration(1, delay: 0, options: opts, animations: {
                UIView.setAnimationRepeatCount(Float(count)) // I really don't like this
                self.v.center.x += 100
                }, completion: {
                    _ in
                    self.v.center.x = xorig
            })
        case 2:
            let opts = UIViewAnimationOptions.Autoreverse
            let xorig = self.v.center.x
            UIView.animateWithDuration(1, delay: 0, options: opts, animations: {
                self.v.center.x += 100
                }, completion: {
                    _ in
                    self.v.center.x = xorig
                    if count > 1 {
                        self.animate(count-1)
                    }
            })
        default: break
        }
    }
    
}

