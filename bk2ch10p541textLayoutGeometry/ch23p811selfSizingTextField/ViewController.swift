

import UIKit
func lend<T where T:NSObject> (closure:(T)->()) -> T {
    let orig = T()
    closure(orig)
    return orig
}

class ViewController: UIViewController {
    
    @IBOutlet var tv : UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let path = NSBundle.mainBundle().pathForResource("brillig", ofType: "txt")!
        let s = String(contentsOfFile:path, encoding: NSUTF8StringEncoding, error: nil)
        let s2 = s!.stringByReplacingOccurrencesOfString("\n", withString: "")
        let mas = NSMutableAttributedString(string:s2, attributes:[
            NSFontAttributeName: UIFont(name:"GillSans", size:20)!
            ])
        
        mas.addAttribute(NSParagraphStyleAttributeName,
            value:lend(){
                (para:NSMutableParagraphStyle) in
                para.alignment = .Left
                para.lineBreakMode = .ByWordWrapping
            },
            range:NSMakeRange(0,1))

        let r = self.tv.frame
        let lm = MyLayoutManager()
        let ts = NSTextStorage()
        ts.addLayoutManager(lm)
        let tc = NSTextContainer(size:r.size)
        lm.addTextContainer(tc)
        let tv = UITextView(frame:r, textContainer:tc)
        
        self.tv.removeFromSuperview()
        self.view.addSubview(tv)
        self.tv = tv
        
        self.tv.attributedText = mas
        self.tv.scrollEnabled = true
        self.tv.backgroundColor = UIColor.yellowColor()
        self.tv.textContainerInset = UIEdgeInsetsMake(20,20,20,20)
        self.tv.selectable = false
        self.tv.editable = false
                
        self.tv.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("H:|-(10)-[tv]-(10)-|",
                options:nil, metrics:nil, views:["tv":self.tv]))
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("V:[top][tv]-(10)-[bot]",
                options:nil, metrics:nil, views:[
                    "tv":self.tv, "top":self.topLayoutGuide, "bot":self.bottomLayoutGuide
                ]))

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tv.contentOffset = CGPointZero
    }

    @IBAction func doTest(sender:AnyObject) {
        // how far am I scrolled?
        let off = self.tv.contentOffset
        // how far down is the top of the text container?
        let top = self.tv.textContainerInset.top
        // so here's the top-left point within the text container
        var tctopleft = CGPointMake(0, off.y - top)
        // so what's the character index for that?
        //    NSUInteger ix = [self.tv.layoutManager characterIndexForPoint:tctopleft inTextContainer:self.tv.textContainer fractionOfDistanceBetweenInsertionPoints:nil];
        var ix = self.tv.layoutManager.glyphIndexForPoint(tctopleft, inTextContainer:self.tv.textContainer, fractionOfDistanceThroughGlyph:nil)
        let frag = self.tv.layoutManager.lineFragmentRectForGlyphAtIndex(ix, effectiveRange:nil)
        if tctopleft.y > frag.origin.y + 0.5*frag.size.height {
            tctopleft.y += frag.size.height
            ix = self.tv.layoutManager.glyphIndexForPoint(tctopleft, inTextContainer:self.tv.textContainer, fractionOfDistanceThroughGlyph:nil)
        }
        let charRange = self.tv.layoutManager.characterRangeForGlyphRange(NSMakeRange(ix,0), actualGlyphRange:nil)
        ix = charRange.location
        
        
        // what word is that?
        let sch = NSLinguisticTagSchemeTokenType
        let t = NSLinguisticTagger(tagSchemes:[sch], options:0)
        t.string = self.tv.text
        var r : NSRange = NSMakeRange(0,0)
        let tag = t.tagAtIndex(ix, scheme:sch, tokenRange:&r, sentenceRange:nil)
        if tag == NSLinguisticTagWord {
            println((self.tv.text as NSString).substringWithRange(r))
        }
        
        let lm = self.tv.layoutManager as! MyLayoutManager
        lm.wordRange = r
        lm.invalidateDisplayForCharacterRange(r)

    }
}
