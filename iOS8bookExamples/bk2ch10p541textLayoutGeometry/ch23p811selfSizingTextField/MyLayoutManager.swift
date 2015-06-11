
import UIKit

class MyLayoutManager : NSLayoutManager {
    
    var wordRange : NSRange = NSMakeRange(0,0)
    
    override func drawBackgroundForGlyphRange(glyphsToShow: NSRange, atPoint origin: CGPoint) {
        super.drawBackgroundForGlyphRange(glyphsToShow, atPoint:origin)
        if self.wordRange.length == 0 {
            return
        }
        var range = self.glyphRangeForCharacterRange(self.wordRange, actualCharacterRange:nil)
        range = NSIntersectionRange(glyphsToShow, range)
        if range.length == 0 {
            return
        }
        if let tc = self.textContainerForGlyphAtIndex(range.location, effectiveRange:nil) {
            var r = self.boundingRectForGlyphRange(range, inTextContainer:tc)
            r.origin.x += origin.x
            r.origin.y += origin.y
            let c = UIGraphicsGetCurrentContext()
            CGContextSaveGState(c)
            CGContextSetStrokeColorWithColor(c, UIColor.blackColor().CGColor)
            CGContextSetLineWidth(c, 1.0)
            CGContextStrokeRect(c, r)
            CGContextRestoreGState(c)
        }
    }
    
    
}
