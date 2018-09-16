

import UIKit

class StringDrawer : UIView {
    @NSCopying var attributedText : NSAttributedString! {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    let which = 2
    
    override func draw(_ rect: CGRect) {
        
        switch which {
        case 1:
            let r = rect.offsetBy(dx: 0, dy: 2)
            let options : NSStringDrawingOptions = [.truncatesLastVisibleLine, .usesLineFragmentOrigin]
            self.attributedText.draw(with:r, options: options, context: nil)
        case 2:
            let lm = NSLayoutManager()
            let ts = NSTextStorage(attributedString:self.attributedText)
            ts.addLayoutManager(lm)
            let tc = NSTextContainer(size:rect.size)
            lm.addTextContainer(tc)
            tc.lineBreakMode = .byTruncatingTail //
            tc.lineFragmentPadding = 0
            let r = lm.glyphRange(for:tc)
            lm.drawBackground(forGlyphRange:r, at:CGPoint(0,2))
            lm.drawGlyphs(forGlyphRange: r, at:CGPoint(0,2))
        default:break
        }
        
    }
}
