

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
    class func animateWithTimes(times:Int,
        duration dur: NSTimeInterval,
        delay del: NSTimeInterval,
        options opts: UIViewAnimationOptions,
        animations anim: () -> Void,
        completion comp: ((Bool) -> Void)?) {
            func animHelper(t:Int,
                _ dur: NSTimeInterval,
                _ del: NSTimeInterval,
                _ opt: UIViewAnimationOptions,
                _ anim: () -> Void,
                _ com: ((Bool) -> Void)?) {
                    UIView.animateWithDuration(dur,
                        delay: del, options: opt,
                        animations: anim, completion: {
                            done in
                            if com != nil {
                                com!(done)
                            }
                            if t > 0 {
                                delay(0) {
                                    animHelper(t-1, dur, del, opt, anim, com)
                                }
                            }
                    })
            }
            animHelper(times-1, dur, del, opts, anim, comp)
    }

}

class ViewController: UIViewController {
    @IBOutlet weak var v: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let which = 9
        
        delay(3) {
            print(0)
            print(self.v.center.y)
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
                UIView.animateWithDuration(1, animations: {
                    self.v.backgroundColor = UIColor.redColor()
                    UIView.performWithoutAnimation {
                        self.v.center.y += 100
                    }
                })
            case 5:
                // need to think about this one
                UIView.animateWithDuration(2, animations: {
                    print(2)
                    print(self.v.center.y)
                    self.v.center.y = 100
                    print(3)
                    print(self.v.center.y)
                    }, completion: {
                        _ in
                        print(4)
                        print(self.v.center.y)
                })
                self.v.center.y = 300
                print(1)
                print(self.v.center.y)
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
                // let opts = UIViewAnimationOptions.BeginFromCurrentState
                UIView.animateWithDuration(1, delay: 0, options: [],
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
                        delay(0) {
                            self.animate(count-1)
                        }
                    }
            })
        default: break
        }
    }
    
}

