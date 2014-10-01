import UIKit

class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    
    @IBAction func doButton(sender : AnyObject?) {
        self.animate()
    }
    
    func animate() {
        var p = self.v.center
        let opt1 : UIViewKeyframeAnimationOptions = .CalculationModeLinear
        let opt2 : UIViewAnimationOptions = .CurveLinear
        let opts = opt1 | UIViewKeyframeAnimationOptions(opt2.rawValue)
        let dur = 0.25
        var start = 0.0
        let dx : CGFloat = 100
        let dy : CGFloat = 50
        var dir : CGFloat = 1
        UIView.animateKeyframesWithDuration(4,
            delay: 0, options: opts,
            animations: {
                // self.v.alpha = 0
                UIView.addKeyframeWithRelativeStartTime(start,
                    relativeDuration: dur,
                    animations: {
                        p.x += dx*dir; p.y += dy
                        self.v.center = p
                    })
                start += dur; dir *= -1
                UIView.addKeyframeWithRelativeStartTime(start,
                    relativeDuration: dur,
                    animations: {
                        p.x += dx*dir; p.y += dy
                        self.v.center = p
                    })
                start += dur; dir *= -1
                UIView.addKeyframeWithRelativeStartTime(start,
                    relativeDuration: dur,
                    animations: {
                        p.x += dx*dir; p.y += dy
                        self.v.center = p
                    })
                start += dur; dir *= -1
                UIView.addKeyframeWithRelativeStartTime(start,
                    relativeDuration: dur,
                    animations: {
                        p.x += dx*dir; p.y += dy
                        self.v.center = p
                    })
            }, completion: nil)
        
    }
    
}
