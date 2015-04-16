

import UIKit

class StringDrawer : UIView {
    @NSCopying var attributedText : NSAttributedString! {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        let r = rect.rectByOffsetting(dx: 0, dy: 2)
        // bug trying to "or" NSStringDrawingOptions values together...
        // fixed in Swift 1.2 / Xcode 6.3!
        let opts : NSStringDrawingOptions = .TruncatesLastVisibleLine | .UsesLineFragmentOrigin
        
        let context = NSStringDrawingContext()
        context.minimumScaleFactor = 0.5 // does nothing
        
        self.attributedText.drawWithRect(r, options: opts, context: context)
        
        println(context.totalBounds)
    }
}