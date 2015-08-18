

import UIKit

class ViewController : UIViewController {
    @IBOutlet var sv : UIScrollView!
    var didSetup = false
    
    // storyboard doesn't use autolayout

    
    override func viewDidLayoutSubviews() {
        if !didSetup {
            didSetup = true
            self.sv.contentSize = self.sv.subviews[0].bounds.size
        }
    }
    
    // no code for content inset - automaticallyAdjustsScrollViewInsets takes care of it

}
