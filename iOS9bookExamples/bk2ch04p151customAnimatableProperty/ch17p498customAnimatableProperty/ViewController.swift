
import UIKit


class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    
    @IBAction func doButton (sender:AnyObject) {
        let lay = self.v.layer as! MyLayer
        let cur = lay.thickness
        let val : CGFloat = cur == 10 ? 0 : 10
        lay.thickness = val
        let ba = CABasicAnimation(keyPath:"thickness")
        ba.fromValue = cur
        lay.addAnimation(ba, forKey:nil)
    }
    
}
