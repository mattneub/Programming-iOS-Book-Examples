

import UIKit

class StringDrawer : UIView {
    @NSCopying var attributedText : NSAttributedString! {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        let r = rect.offsetBy(dx: 0, dy: 2)
        // just proving it's now an OptionSetType
        let opts : NSStringDrawingOptions = [.TruncatesLastVisibleLine, .UsesLineFragmentOrigin]
        
        let context = NSStringDrawingContext()
        context.minimumScaleFactor = 0.5 // does nothing
        
        self.attributedText.drawWithRect(r, options: opts, context: context)
        
        print(context.totalBounds)
    }
}