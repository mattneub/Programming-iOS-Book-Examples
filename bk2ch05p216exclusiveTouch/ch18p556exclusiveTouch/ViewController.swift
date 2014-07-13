
import UIKit

class ViewController : UIViewController {
    @IBAction func pinch(sender:AnyObject?) {
        println("pinch")
    }
}

class MyView : UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        // uncomment and try again
        // self.exclusiveTouch = true
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        println(self)
    }
}
