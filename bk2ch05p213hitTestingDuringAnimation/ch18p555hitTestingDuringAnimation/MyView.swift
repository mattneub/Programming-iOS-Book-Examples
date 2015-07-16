

import UIKit


class MyView : UIView {
    @IBOutlet var v : UIView! // the animated subview
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let t = UITapGestureRecognizer(target: self, action: "tap:")
        self.v.addGestureRecognizer(t)
        t.cancelsTouchesInView = false
        // uncomment next line to see how button, even if tappable, "swallows the touch" while animating
        // self.v.removeGestureRecognizer(t)
    }
    
    func tap(g:UIGestureRecognizer!) {
        print("tap! (gesture recognizer)")
    }
        
}
