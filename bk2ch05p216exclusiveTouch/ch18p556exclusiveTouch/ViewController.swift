
import UIKit

class ViewController : UIViewController {
    @IBAction func pinch(sender:AnyObject?) {
        println("pinch")
    }
    
    @IBAction func switched(sender: AnyObject) {
        for v in self.view.subviews as! [UIView] {
            if v is MyView {
                let sw = sender as! UISwitch
                v.exclusiveTouch = sw.on
            }
        }
    }
    
}

class MyView : UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent e: UIEvent) {
        println(self)
    }
    
}
