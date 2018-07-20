

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
    
    // iOS 10 way:
    // no code for content inset - automaticallyAdjustsScrollViewInsets takes care of it

    // 11 iOS way:
    // no need for automaticallyAdjustsScrollViewInsets;
    // it can be off, bounces vertically takes care of it (in storyboard)
}
