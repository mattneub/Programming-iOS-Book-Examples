

import UIKit

class StringDrawer : UIView {
    @NSCopying var attributedText : NSAttributedString! {
    didSet {
        self.setNeedsDisplay()
    }
    }
    
    override func drawRect(rect: CGRect) {
        let r = rect.rectByOffsetting(dx: 0, dy: 2)
        // unfortunately there's a huge bug in Swift:
        // we can't "or" NSStringDrawingOptions values together
        // I've resorted to the assistance of Objective-C
        let options = NSString.combine(.TruncatesLastVisibleLine, with:.UsesLineFragmentOrigin)
        self.attributedText.drawWithRect(r, options: options, context: nil)
    }
}