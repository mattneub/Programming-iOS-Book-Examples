

import UIKit

func lend<T where T:NSObject> (closure:(T)->()) -> T {
    let orig = T()
    closure(orig)
    return orig
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let con = NSStringDrawingContext()
        
        // testing string measurement
        
        let s = self.makeAttributedString()
        let r = s.boundingRectWithSize(CGSizeMake(400,10000), options: .UsesLineFragmentOrigin, context: con)
        print(r) // about 150 tall, sounds right to me :)
        print(con.totalBounds) // same answer
        
        // testing minimumScaleFactor; we never get an actual scale factor other than 1
        
        do {
            for w in [240,230,220] {
                let s2 = NSMutableAttributedString(string:"Little poltergeists make up the principle form")
                let p = lend {
                    (p:NSMutableParagraphStyle) in
                    p.allowsDefaultTighteningForTruncation = false
                    p.lineBreakMode = .ByTruncatingTail
                }
                s2.addAttribute(NSParagraphStyleAttributeName, value: p, range: NSMakeRange(0,1))
                con.minimumScaleFactor = 0.5
                s2.boundingRectWithSize(CGSizeMake(CGFloat(w),10000), options: [.UsesLineFragmentOrigin], context: con)
                print(w, con.totalBounds, con.actualScaleFactor)
            }
        }
        
        do {
            for w in [240,230,220] {
                let s2 = NSMutableAttributedString(string:"Little poltergeists make up the principle form")
                let p = lend {
                    (p:NSMutableParagraphStyle) in
                    // this new feature does make a difference, but not in the scale factor
                    p.allowsDefaultTighteningForTruncation = true
                    p.lineBreakMode = .ByTruncatingTail
                }
                s2.addAttribute(NSParagraphStyleAttributeName, value: p, range: NSMakeRange(0,1))
                con.minimumScaleFactor = 0.5
                s2.boundingRectWithSize(CGSizeMake(CGFloat(w),10000), options: [.UsesLineFragmentOrigin, .TruncatesLastVisibleLine], context: con)
                print(w, con.totalBounds, con.actualScaleFactor)
            }
        }

        
        
    }
    
    func makeAttributedString() -> NSAttributedString {
        var content : NSMutableAttributedString!
        var content2 : NSMutableAttributedString!
        
        let s1 = "The Gettysburg Address, as delivered on a certain occasion " +
        "(namely Thursday, November 19, 1863) by A. Lincoln"
        content = NSMutableAttributedString(string:s1, attributes:[
            NSFontAttributeName: UIFont(name:"Arial-BoldMT", size:15)!,
            NSForegroundColorAttributeName: UIColor(red:0.251, green:0.000, blue:0.502, alpha:1)]
        )
        let r = (s1 as NSString).rangeOfString("Gettysburg Address")
        let atts = [
            NSStrokeColorAttributeName: UIColor.redColor(),
            NSStrokeWidthAttributeName: -2.0
        ]
        content.addAttributes(atts, range: r)
        
        content.addAttribute(NSParagraphStyleAttributeName,
            value:lend() {
                (para : NSMutableParagraphStyle) in
                para.headIndent = 10
                para.firstLineHeadIndent = 10
                para.tailIndent = -10
                para.lineBreakMode = .ByWordWrapping
                para.alignment = .Center
                para.paragraphSpacing = 15
            }, range:NSMakeRange(0,1))
        
        var s2 = "Fourscore and seven years ago, our fathers brought forth " +
        "upon this continent a new nation, conceived in liberty and dedicated "
        s2 = s2 + "to the proposition that all men are created equal."
        content2 = NSMutableAttributedString(string:s2, attributes: [
            NSFontAttributeName: UIFont(name:"HoeflerText-Black", size:16)!
            ])
        content2.addAttributes([
            NSFontAttributeName: UIFont(name:"HoeflerText-Black", size:24)!,
            NSExpansionAttributeName: 0.3,
            NSKernAttributeName: -4 // negative kerning bug fixed in iOS 8
            ], range:NSMakeRange(0,1))
        
        content2.addAttribute(NSParagraphStyleAttributeName,
            value:lend() {
                (para2 : NSMutableParagraphStyle) in
                para2.headIndent = 10
                para2.firstLineHeadIndent = 10
                para2.tailIndent = -10
                para2.lineBreakMode = .ByWordWrapping
                para2.alignment = .Justified
                para2.lineHeightMultiple = 1.2
                para2.hyphenationFactor = 1.0
            }, range:NSMakeRange(0,1))
        
        let end = content.length
        content.replaceCharactersInRange(NSMakeRange(end, 0), withString:"\n")
        content.appendAttributedString(content2)
        
        return content
        
    }
    




}

