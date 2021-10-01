
import UIKit

var start = Date()

class ViewController : UIViewController {
    @IBOutlet var v : UIView!
    
    @IBAction func doButton (_ sender: Any) {
        start = Date()
        
        let lay = self.v.layer as! MyLayer
        let cur = lay.thickness
        let val : CGFloat = cur == 10 ? 0 : 10
        lay.thickness = val
        let ba = CABasicAnimation(keyPath:#keyPath(MyLayer.thickness))
        ba.fromValue = cur
        lay.add(ba, forKey:nil)
    }
    
}
