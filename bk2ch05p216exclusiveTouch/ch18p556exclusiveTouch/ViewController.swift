
import UIKit

class ViewController : UIViewController {
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func pinch(sender:AnyObject?) {
        print("pinch")
    }
    
    @IBAction func switched(sender: AnyObject) {
        let sw = sender as! UISwitch
        for v in self.view.subviews {
            if v is MyView || v is UIButton {
                v.exclusiveTouch = sw.on
            }
        }
    }
    
}

class MyView : UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent e: UIEvent?) {
        print(self)
    }
    
}
