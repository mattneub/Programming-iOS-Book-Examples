import UIKit

class ViewController : UIViewController {
    
    @IBOutlet var v : UIView!
    
    let which = 2
    
    @IBAction func doButton(sender : AnyObject?) {
        switch which {
        case 1:
            UIView.animateWithDuration(0.8, delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 20,
                options: [],
                animations: {
                    self.v.center.y += 100
                }, completion: nil)
        case 2:
            // new in iOS 9, springing is exposed at layer level
            CATransaction.setDisableActions(true)
            self.v.layer.position.y += 100
            let anim = CASpringAnimation(keyPath: "position")
            anim.damping = 0.7
            anim.initialVelocity = 20
            anim.mass = 0.04
            anim.stiffness = 4
            anim.duration = 0.8
            print(anim.settlingDuration)
            self.v.layer.addAnimation(anim, forKey: nil)
        default:break
        }
    }
}
