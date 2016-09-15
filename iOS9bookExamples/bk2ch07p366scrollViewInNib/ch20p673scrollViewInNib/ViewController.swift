

import UIKit

class ViewController : UIViewController {
    
    @IBOutlet var sv : UIScrollView!
    @IBOutlet var cv : UIView!
    var didSetup = false
    
    // storyboard doesn't use autolayout

    override func viewDidLayoutSubviews() {
        if !self.didSetup {
            self.didSetup = true
            self.sv.contentSize = self.cv.bounds.size
        }
    }
    
    
}
