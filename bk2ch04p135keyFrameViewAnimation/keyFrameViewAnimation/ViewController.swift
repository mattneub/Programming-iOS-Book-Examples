import UIKit

class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    
    @IBAction func doButton(_ sender: AnyObject?) {
        self.animate()
    }
    
    func animate() {
        var p = self.v.center
        var opts : UIViewKeyframeAnimationOptions = [] // calculationModeLinear
        let opt2 : UIViewAnimationOptions = .curveLinear
        _ = opts.insert(UIViewKeyframeAnimationOptions(rawValue:opt2.rawValue))
        let dur = 0.25
        var start = 0.0
        let dx : CGFloat = 100
        let dy : CGFloat = 50
        var dir : CGFloat = 1
        UIView.animateKeyframes(withDuration:4,
            delay: 0, options: opts,
            animations: {
                // self.v.alpha = 0
                UIView.addKeyframe(withRelativeStartTime:start,
                    relativeDuration: dur,
                    animations: {
                        p.x += dx*dir; p.y += dy
                        self.v.center = p
                    })
                start += dur; dir *= -1
                UIView.addKeyframe(withRelativeStartTime:start,
                    relativeDuration: dur,
                    animations: {
                        p.x += dx*dir; p.y += dy
                        self.v.center = p
                    })
                start += dur; dir *= -1
                UIView.addKeyframe(withRelativeStartTime:start,
                    relativeDuration: dur,
                    animations: {
                        p.x += dx*dir; p.y += dy
                        self.v.center = p
                    })
                start += dur; dir *= -1
                UIView.addKeyframe(withRelativeStartTime:start,
                    relativeDuration: dur,
                    animations: {
                        p.x += dx*dir; p.y += dy
                        self.v.center = p
                    })
            }, completion: nil)
        
    }
    
}
