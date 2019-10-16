

import UIKit

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



class ViewController : UIViewController {
    @IBOutlet var sv : UIScrollView!
    var didSetup = false
    
    // storyboard doesn't use autolayout

    
    override func viewDidLayoutSubviews() {
        if !didSetup {
            didSetup = true
            self.sv.contentSize = self.sv.subviews[0].bounds.size
            // we don't need this...
            // self.sv.contentInsetAdjustmentBehavior = .always
            // but we do need to work around incorrect initial scroll
            self.sv.scrollRectToVisible(CGRect(0,0,1,1), animated: false)
        }
    }
    
    @IBAction func doTopButton(_ sender: Any) {
        // to scroll to top, this is _not_ what to say!
        // self.sv.contentOffset.y = 0
        // you need to take into account the content inset
        self.sv.contentOffset.y = -self.sv.adjustedContentInset.top
    }
    
    // iOS 11 way:
    // automaticallyAdjustsScrollViewInsets is OFF in the nib!
    // instead, we use the scroll view's own behavior
    
}
