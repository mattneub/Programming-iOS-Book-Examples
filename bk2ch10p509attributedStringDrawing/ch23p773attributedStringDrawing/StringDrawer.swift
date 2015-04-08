

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
        // let opts = NSString.combine(.TruncatesLastVisibleLine, with:.UsesLineFragmentOrigin)
        // let opts = NSStringDrawingOptions.UsesLineFragmentOrigin
        
        // fixed in Swift 1.2 / Xcode 6.3!
        let opts : NSStringDrawingOptions = .TruncatesLastVisibleLine | .UsesLineFragmentOrigin
        
        let context = NSStringDrawingContext()
        context.minimumScaleFactor = 0.5 // does nothing
        
        self.attributedText.drawWithRect(r, options: opts, context: context)
        
        println(context.totalBounds)
    }
}