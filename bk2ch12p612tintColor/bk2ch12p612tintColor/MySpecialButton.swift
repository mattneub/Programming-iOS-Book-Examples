

import UIKit

class MySpecialButton : UIButton {
    
    var originalTitle : NSAttributedString?
    var dimmedTitle : NSAttributedString?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.originalTitle = self.attributedTitle(for:.normal)!
        let t = NSMutableAttributedString(attributedString: self.attributedTitle(for:.normal)!)
        t.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: NSMakeRange(0,t.length))
        self.dimmedTitle = t
    }
    override func tintColorDidChange() {
        self.setAttributedTitle(
            self.tintAdjustmentMode == .dimmed ? self.dimmedTitle : self.originalTitle,
            for:.normal)
    }
}
