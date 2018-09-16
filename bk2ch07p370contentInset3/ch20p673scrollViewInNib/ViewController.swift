

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
    @IBAction func doTopButton(_ sender: Any) {
        // to scroll to top, this is _not_ what to say!
        // self.sv.contentOffset.y = 0
        // you need to take into account the content inset
        if #available(iOS 11.0, *) {
            self.sv.contentOffset.y = -self.sv.adjustedContentInset.top
        } else {
            // Fallback on earlier versions
        }
    }
    
    // iOS 10 way:
    // no code for content inset - automaticallyAdjustsScrollViewInsets takes care of it

    // 11 iOS way:
    // no need for automaticallyAdjustsScrollViewInsets;
    // it can be off, alwaysBounceVertical takes care of it (in storyboard)
}
