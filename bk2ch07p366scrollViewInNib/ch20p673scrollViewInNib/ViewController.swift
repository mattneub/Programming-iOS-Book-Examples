

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
    @IBOutlet var cv : UIView!
    var didSetup = false
    
    override func viewDidLayoutSubviews() {
        if !self.didSetup {
            self.didSetup = true
            self.sv.contentSize = self.cv.bounds.size
            // prevent automatic behavior, scroll position issue at launch
            // can't do this in nib editor unless using autolayout in nib
            // self.sv.contentInsetAdjustmentBehavior = .never
            // I still like this trick better, as it says what it does
            // sv.scrollRectToVisible(CGRect(0,0,1,1), animated: false)

        }
        print(self.sv.contentSize)
    }
    
    
}
