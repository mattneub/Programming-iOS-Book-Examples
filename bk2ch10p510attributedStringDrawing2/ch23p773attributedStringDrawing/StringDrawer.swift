

import UIKit

class StringDrawer : UIView {
    @NSCopying var attributedText : NSAttributedString! {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        let which = 1
        switch which {
        case 1:
            let r = rect.rectByOffsetting(dx: 0, dy: 2)
            let options : NSStringDrawingOptions = .TruncatesLastVisibleLine | .UsesLineFragmentOrigin
            self.attributedText.drawWithRect(r, options: options, context: nil)
        case 2:
            let lm = NSLayoutManager()
            let ts = NSTextStorage(attributedString:self.attributedText)
            ts.addLayoutManager(lm)
            let tc = NSTextContainer(size:rect.size)
            lm.addTextContainer(tc)
            tc.lineBreakMode = .ByTruncatingTail
            tc.lineFragmentPadding = 0
            let r = lm.glyphRangeForTextContainer(tc)
            lm.drawBackgroundForGlyphRange(r, atPoint:CGPointMake(0,2))
            lm.drawGlyphsForGlyphRange(r, atPoint:CGPointMake(0,2))
        default:break
        }
        
    }
}