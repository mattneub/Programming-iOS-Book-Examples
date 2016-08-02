
import UIKit

class ViewController : UIViewController {
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func pinch(_ sender:AnyObject?) {
        print("pinch")
    }
    
    @IBAction func switched(_ sender: AnyObject) {
        let sw = sender as! UISwitch
        for v in self.view.subviews {
            if v is MyView || v is UIButton {
                v.isExclusiveTouch = sw.isOn
            }
        }
    }
    
}

class MyView : UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with e: UIEvent?) {
        print(self)
    }
    
}
