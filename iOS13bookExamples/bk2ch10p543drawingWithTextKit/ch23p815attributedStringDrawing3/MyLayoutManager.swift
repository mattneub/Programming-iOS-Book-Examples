

import UIKit

class MyLayoutManager : NSLayoutManager {
    
    var wordRange : NSRange = NSMakeRange(0,0)
    
    override func drawBackground(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        super.drawBackground(forGlyphRange:glyphsToShow, at:origin)
        if self.wordRange.length == 0 {
            return
        }
        var range = self.glyphRange(forCharacterRange:self.wordRange, actualCharacterRange:nil)
        range = NSIntersectionRange(glyphsToShow, range)
        if range.length == 0 {
            return
        }
        if let tc = self.textContainer(forGlyphAt:range.location, effectiveRange:nil) {
            var r = self.boundingRect(forGlyphRange:range, in:tc)
            r.origin.x += origin.x
            r.origin.y += origin.y
            r = r.insetBy(dx: -2, dy: 0)
            let c = UIGraphicsGetCurrentContext()!
            c.saveGState()
            c.setStrokeColor(UIColor.black.cgColor)
            c.setLineWidth(1.0)
            c.stroke(r)
            c.restoreGState()
        }

    }
    
    
}
