

import UIKit
func lend<T> (closure:(T)->()) -> T where T:NSObject {
    let orig = T()
    closure(orig)
    return orig
}

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



class ViewController: UIViewController {
    
    @IBOutlet var tv : UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let path = Bundle.main.path(forResource: "brillig", ofType: "txt")!
        let s = try! String(contentsOfFile:path)
        let s2 = s.replacingOccurrences(of:"\n", with: "")
        let mas = NSMutableAttributedString(string:s2 + " " + s2, attributes:[
            NSFontAttributeName: UIFont(name:"GillSans", size:20)!
            ])
        
        mas.addAttribute(NSParagraphStyleAttributeName,
            value:lend(){
                (para:NSMutableParagraphStyle) in
                para.alignment = .left
                para.lineBreakMode = .byWordWrapping
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
        self.tv.isScrollEnabled = true
        self.tv.backgroundColor = .yellow
        self.tv.textContainerInset = UIEdgeInsetsMake(20,20,20,20)
        self.tv.isSelectable = false
        self.tv.isEditable = false
                
        self.tv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat:"H:|-(10)-[tv]-(10)-|",
                metrics:nil, views:["tv":self.tv]),
            NSLayoutConstraint.constraints(withVisualFormat:"V:[top][tv]-(10)-[bot]",
                metrics:nil, views:[
                    "tv":self.tv, "top":self.topLayoutGuide, "bot":self.bottomLayoutGuide
                ])
            ].flatMap{$0})

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tv.contentOffset = .zero
    }

    @IBAction func doTest(_ sender:AnyObject) {
        // how far am I scrolled?
        let off = self.tv.contentOffset
        // how far down is the top of the text container?
        let top = self.tv.textContainerInset.top
        // so here's the top-left point within the text container
        var tctopleft = CGPoint(0, off.y - top)
        // so what's the character index for that?
        //    NSUInteger ix = [self.tv.layoutManager characterIndexForPoint:tctopleft inTextContainer:self.tv.textContainer fractionOfDistanceBetweenInsertionPoints:nil];
        var ix = self.tv.layoutManager.glyphIndex(for:tctopleft, in:self.tv.textContainer, fractionOfDistanceThroughGlyph:nil)
        let frag = self.tv.layoutManager.lineFragmentRect(forGlyphAt:ix, effectiveRange:nil)
        if tctopleft.y > frag.origin.y + 0.5*frag.size.height {
            tctopleft.y += frag.size.height
            ix = self.tv.layoutManager.glyphIndex(for:tctopleft, in:self.tv.textContainer, fractionOfDistanceThroughGlyph:nil)
        }
        let charRange = self.tv.layoutManager.characterRange(forGlyphRange: NSMakeRange(ix,0), actualGlyphRange:nil)
        ix = charRange.location
        
        
        // what word is that?
        let sch = NSLinguisticTagSchemeTokenType
        let t = NSLinguisticTagger(tagSchemes:[sch], options:0)
        t.string = self.tv.text
        var r : NSRange = NSMakeRange(0,0)
        let tag = t.tag(at:ix, scheme:sch, tokenRange:&r, sentenceRange:nil)
        if tag == NSLinguisticTagWord {
            print((self.tv.text as NSString).substring(with:r))
        }
        
        let lm = self.tv.layoutManager as! MyLayoutManager
        lm.wordRange = r
        lm.invalidateDisplay(forCharacterRange:r)

    }
}
