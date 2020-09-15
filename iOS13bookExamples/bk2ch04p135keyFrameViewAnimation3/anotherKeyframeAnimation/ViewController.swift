

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController: UIViewController {
    
    @IBOutlet var reds : [UIView]!

    override func viewDidLoad() {
        super.viewDidLoad()
        delay(3) {
            self.test()
        }
    }
    
    func test() {
        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [], animations: {
            var start = 0.0
            var ix = 0
            UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: 0.5) {
                self.reds[ix].center.y += 100
            }
            start += 0.2; ix += 1
            UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: 0.5) {
                self.reds[ix].center.y += 100
            }
            start += 0.2; ix += 1
            UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: 0.5) {
                self.reds[ix].center.y += 100
            }
            start += 0.2; ix += 1
            UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: 0.5) {
                self.reds[ix].center.y += 100
            }
            start += 0.2; ix += 1
            UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: 0.5) {
                self.reds[ix].center.y += 100
            }
        })
    }



}

