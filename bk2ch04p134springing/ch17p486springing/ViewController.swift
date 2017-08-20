import UIKit

class ViewController : UIViewController {
    
    @IBOutlet var v : UIView!
    
    let which = 1
    
    @IBAction func doButton(_ sender: Any?) {
        switch which {
        case 1:
            UIView.animate(withDuration:0.8, delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 20,
                animations: {
                    self.v.center.y += 100
                })
        case 2:
            // new in iOS 9, springing is exposed at layer level
            CATransaction.setDisableActions(true)
            self.v.layer.position.y += 100
            let anim = CASpringAnimation(keyPath: #keyPath(CALayer.position))
            anim.damping = 0.7
            anim.initialVelocity = 20
            anim.mass = 0.04
            anim.stiffness = 4
            anim.duration = 1 // ignored, but you need to supply something
            print(anim.settlingDuration)
            self.v.layer.add(anim, forKey: nil)
        default:break
        }
    }
}
