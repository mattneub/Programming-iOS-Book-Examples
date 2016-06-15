

import UIKit
func delay(_ delay:Double, closure:()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.after(when: when, execute: closure)
}

extension UIView {
    class func animate(times:Int,
        duration dur: TimeInterval,
        delay del: TimeInterval,
        options opts: UIViewAnimationOptions,
        animations anim: () -> Void,
        completion comp: ((Bool) -> Void)?) {
            func helper(_ t:Int,
                _ dur: TimeInterval,
                _ del: TimeInterval,
                _ opt: UIViewAnimationOptions,
                _ anim: () -> Void,
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let which = 11
        
        delay(3) {
            print(0)
            print(self.v.center.y)
            switch which {
            case 1:
                UIView.animate(withDuration:0.4) {
                    self.v.backgroundColor = UIColor.red()
                }
            case 2:
                UIView.animate(withDuration:0.4) {
                    self.v.backgroundColor = UIColor.red()
                    self.v.center.y += 100
                }
            case 3:
                let v2 = UIView()
                v2.backgroundColor = UIColor.black()
                v2.alpha = 0
                v2.frame = self.v.frame
                self.v.superview!.addSubview(v2)
                UIView.animate(withDuration:0.4, animations: {
                    self.v.alpha = 0
                    v2.alpha = 1
                    }, completion: {
                        _ in
                        self.v.removeFromSuperview()
                })
            case 4:
                UIView.perform(.delete, on: [self.v], animations: nil) {
                    _ in print(self.v.superview)
                }
            case 5:
                UIView.animate(withDuration:1) {
                    self.v.backgroundColor = UIColor.red()
                    UIView.performWithoutAnimation {
                        self.v.center.y += 100
                    }
                }
            case 6:
                func report(_ ix:Int) {
                    // at last, the presentation layer comes to you as a CALayer (Optional)
                    let pres = self.v.layer.presentation()!.position.y
                    let model = self.v.center.y
                    print("step \(ix): presentation \(pres), model \(model)")
                }
                UIView.animate(withDuration:2, animations: {
                    report(2)
                    self.v.center.y += 100
                    report(3)
                    }, completion: {
                        _ in
                        report(4)
                })
                self.v.center.y += 300
                report(1)
            case 7:
                UIView.animate(withDuration:2, animations: {
                    self.v.center.y += 100
                    self.v.center.y += 300
                    }, completion: {_ in print(self.v.center.y)})
            case 8:
                let opts = UIViewAnimationOptions.autoreverse
                let xorig = self.v.center.x
                UIView.animate(withDuration:1, delay: 0, options: opts, animations: {
                    self.v.center.x += 100
                    }, completion: {
                        _ in
                        self.v.center.x = xorig
                })
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
            default:break
            }
        }
    }
    
    let whichAnimateWay = 2 // 1 or 2
    
    func animate(count:Int) {
        switch whichAnimateWay {
        case 1:
            let opts = UIViewAnimationOptions.autoreverse
            let xorig = self.v.center.x
            UIView.animate(withDuration:1, delay: 0, options: opts, animations: {
                UIView.setAnimationRepeatCount(Float(count)) // I really don't like this
                self.v.center.x += 100
                }, completion: {
                    _ in
                    self.v.center.x = xorig
            })
        case 2:
            let opts = UIViewAnimationOptions.autoreverse
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

