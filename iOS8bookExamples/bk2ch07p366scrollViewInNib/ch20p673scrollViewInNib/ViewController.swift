

import UIKit

class ViewController : UIViewController {
    
    @IBOutlet var sv : UIScrollView!
    var didSetup = false
    
    // storyboard doesn't use autolayout

    override func viewDidLayoutSubviews() {
        if !self.didSetup {
            self.didSetup = true
            self.sv.contentSize = (self.sv.subviews[0] as! UIView).bounds.size
        }
    }
    
    
}
