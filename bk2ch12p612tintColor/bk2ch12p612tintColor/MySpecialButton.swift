

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class MySpecialButton : UIButton {
    
    var orig : NSAttributedString?
    var dim : NSAttributedString?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.orig = self.attributedTitle(for:.normal)!
        let t = NSMutableAttributedString(attributedString: self.attributedTitle(for:.normal)!)
        t.addAttribute(.foregroundColor, value: UIColor.gray, range: NSMakeRange(0,t.length))
        self.dim = t
    }
    override func tintColorDidChange() {
        self.setAttributedTitle(
           self.tintAdjustmentMode == .dimmed ? self.dim : self.orig,
            for:.normal)
    }
}
