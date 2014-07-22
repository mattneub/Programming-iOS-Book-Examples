
import UIKit
import QuartzCore

class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    
    @IBAction func doButton (sender:AnyObject) {
        let lay = self.v.layer
        let key = "thickness"
        let cur = lay.valueForKey(key) as CGFloat
        let val : Double = cur == 10 ? 0 : 10
        CATransaction.setDisableActions(true)
        lay.setValue(val, forKey:key)
        let ba = CABasicAnimation(keyPath:key)
        ba.fromValue = cur
        ba.toValue = val
        lay.addAnimation(ba, forKey:nil) // explicit
    }
    
    @IBAction func doButton2 (sender:AnyObject) {
        let lay = self.v.layer as MyLayer
        let key = "thickness"
        let val : CGFloat = lay.valueForKey(key) as CGFloat == 10 ? 0 : 10
        lay.thickness = val // implicit
    }
}
