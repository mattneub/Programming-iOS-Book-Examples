

import UIKit

class MySpecialButton : UIButton {
    
    var originalTitle : AttributedString?
    var dimmedTitle : AttributedString?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.originalTitle = self.attributedTitle(for: [])!
        let t = NSMutableAttributedString(attributedString: self.attributedTitle(for: [])!)
        t.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray(), range: NSMakeRange(0,t.length))
        self.dimmedTitle = t
    }
    override func tintColorDidChange() {
        self.setAttributedTitle(
            self.tintAdjustmentMode == .dimmed ? self.dimmedTitle : self.originalTitle,
            for: [])
    }
}
