

import UIKit
import CoreText

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

func lend<T where T:NSObject> (closure:(T)->()) -> T {
    let orig = T()
    closure(orig)
    return orig
}

class StyledText: UIView {
    
    @NSCopying var text = NSAttributedString() // shut up the compiler
    var lm : NSLayoutManager!
    var tc : NSTextContainer!
    var tc2 : NSTextContainer!
    var ts : NSTextStorage!
    var r1 = CGRectZero
    var r2 = CGRectZero
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let path = NSBundle.mainBundle().pathForResource("states", ofType: "txt")!
        let s = try! String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        
        let desc = UIFontDescriptor(name:"Didot", size:18)
        let desc2 = desc.fontDescriptorByAddingAttributes(
            [UIFontDescriptorFeatureSettingsAttribute:[[
                UIFontFeatureTypeIdentifierKey:kLetterCaseType,
                UIFontFeatureSelectorIdentifierKey:kSmallCapsSelector
                ]]]
        )
        let f = UIFont(descriptor: desc2, size: 0)
        
        let d = [NSFontAttributeName:f]
        let mas = NSMutableAttributedString(string: s, attributes: d)
        mas.addAttribute(NSParagraphStyleAttributeName,
            value: lend() {
                (para:NSMutableParagraphStyle) in
                para.alignment = .Center
            },
            range: NSMakeRange(0,mas.length))
        self.text = mas
        
        let tap = UITapGestureRecognizer(target: self, action: "tap:")
        self.addGestureRecognizer(tap)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var r1 = self.bounds
        r1.origin.y += 2 // a little top space
        r1.size.width /= 2.0 // column 1
        var r2 = r1
        r2.origin.x += r2.size.width // column 2
        let lm = MyLayoutManager()
        let ts = NSTextStorage(attributedString:self.text)
        ts.addLayoutManager(lm)
        let tc = NSTextContainer(size:r1.size)
        lm.addTextContainer(tc)
        let tc2 = NSTextContainer(size:r2.size)
        lm.addTextContainer(tc2)
        
        self.lm = lm; self.ts = ts; self.tc = tc; self.tc2 = tc2
        self.r1 = r1; self.r2 = r2
    }
    
    override func drawRect(rect: CGRect) {
        let range1 = self.lm.glyphRangeForTextContainer(self.tc)
        self.lm.drawBackgroundForGlyphRange(range1, atPoint: self.r1.origin)
        self.lm.drawGlyphsForGlyphRange(range1, atPoint: self.r1.origin)
        let range2 = self.lm.glyphRangeForTextContainer(self.tc2)
        self.lm.drawBackgroundForGlyphRange(range2, atPoint: self.r2.origin)
        self.lm.drawGlyphsForGlyphRange(range2, atPoint: self.r2.origin)
    }
    
    func tap (g : UIGestureRecognizer) {
        // which column is it in?
        var p = g.locationInView(self)
        var tc = self.tc
        if !CGRectContainsPoint(self.r1, p) {
            tc = self.tc2
            p.x -= self.r1.size.width
        }
        var f : CGFloat = 0
        let ix = self.lm.glyphIndexForPoint(p, inTextContainer:tc, fractionOfDistanceThroughGlyph:&f)
        var glyphRange : NSRange = NSMakeRange(0,0)
        self.lm.lineFragmentRectForGlyphAtIndex(ix, effectiveRange:&glyphRange)
        // if ix is the first glyph of the line and f is 0...
        // or ix is the last glyph of the line and f is 1...
        // you missed the word entirely
        if ix == glyphRange.location && f == 0.0 {
            return
        }
        if ix == glyphRange.location + glyphRange.length - 1 && f == 1.0 {
            return
        }
        // eliminate control character glyphs at end
        func lastCharIsControl () -> Bool {
            let lastCharRange = glyphRange.location + glyphRange.length - 1
            let property = self.lm.propertyForGlyphAtIndex(lastCharRange)
            // let ok = property.contains[.ControlCharacter]
            let mask1 = property.rawValue
            let mask2 = NSGlyphProperty.ControlCharacter.rawValue
            return mask1 & mask2 != 0
        }
        while lastCharIsControl() {
            glyphRange.length -= 1
        }
        // okay, we've got the range!
        let characterRange = self.lm.characterRangeForGlyphRange(glyphRange, actualGlyphRange:nil)
        let s = (self.text.string as NSString).substringWithRange(characterRange) // state name
        print("you tapped \(s)")
        let lm = self.lm as! MyLayoutManager
        lm.wordRange = characterRange
        self.setNeedsDisplay()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        delay(0.3) {
            lm.wordRange = NSMakeRange(0, 0)
            self.setNeedsDisplay()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
    }

}
