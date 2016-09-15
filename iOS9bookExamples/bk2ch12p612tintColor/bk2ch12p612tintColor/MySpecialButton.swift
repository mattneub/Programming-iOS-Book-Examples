

import UIKit

class MySpecialButton : UIButton {
    
    var originalTitle : NSAttributedString?
    var dimmedTitle : NSAttributedString?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.originalTitle = self.attributedTitleForState(.Normal)!
        let t = NSMutableAttributedString(attributedString: self.attributedTitleForState(.Normal)!)
        t.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSMakeRange(0,t.length))
        self.dimmedTitle = t
    }
    override func tintColorDidChange() {
        self.setAttributedTitle(
            self.tintAdjustmentMode == .Dimmed ? self.dimmedTitle : self.originalTitle,
            forState: .Normal)
    }
}