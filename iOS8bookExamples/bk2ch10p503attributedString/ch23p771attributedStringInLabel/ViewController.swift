
import UIKit

// useful little utility for encapsulation of "lend me" objects like
// NSMutableParagraphStyle and NSShadow

func lend<T where T:NSObject> (closure:(T)->()) -> T {
    let orig = T()
    closure(orig)
    return orig
}

class ViewController : UIViewController {
    
    @IBOutlet var lab : UILabel!
    @IBOutlet var tv : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.tv.textContainer.lineFragmentPadding = 0 // make it just like the label
        // to show that under identical conditions they do draw identically

        self.tv.scrollEnabled = false // in case setting in the nib doesn't work
        
        var content : NSMutableAttributedString!
        var content2 : NSMutableAttributedString!

        let which = 0 // 0 ... 5
        switch which {
        case 0, 1, 4, 5:
            let s1 = "The Gettysburg Address, as delivered on a certain occasion " +
                "(namely Thursday, November 19, 1863) by A. Lincoln"
            content = NSMutableAttributedString(string:s1, attributes:[
                NSFontAttributeName: UIFont(name:"Arial-BoldMT", size:15)!,
                NSForegroundColorAttributeName: UIColor(red:0.251, green:0.000, blue:0.502, alpha:1)
                ])
            let r = (s1 as NSString).rangeOfString("Gettysburg Address")
            content.addAttributes([
                NSStrokeColorAttributeName: UIColor.redColor(),
                NSStrokeWidthAttributeName: -2.0
                ], range: r)
            self.lab.attributedText = content
            self.tv.attributedText = content
            self.tv.contentInset = UIEdgeInsetsMake(20,0,0,0)
            if which > 0 {fallthrough}
        case 1, 4, 5:
            let para = NSMutableParagraphStyle()
            para.headIndent = 10
            para.firstLineHeadIndent = 10
            para.tailIndent = -10
            para.lineBreakMode = .ByWordWrapping
            para.alignment = .Center
            para.paragraphSpacing = 15
            content.addAttribute(
                NSParagraphStyleAttributeName,
                value:para, range:NSMakeRange(0,1))
            self.lab.attributedText = content
            self.tv.attributedText = content
            self.tv.contentInset = UIEdgeInsetsMake(20,0,0,0)
            if which >= 4 {fallthrough}
        case 2, 3, 4, 5:
            let s2 = "Fourscore and seven years ago, our fathers brought forth " +
                "upon this continent a new nation, conceived in liberty and dedicated " +
                "to the proposition that all men are created equal."
            content2 = NSMutableAttributedString(string:s2, attributes: [
                NSFontAttributeName: UIFont(name:"HoeflerText-Black", size:16)!
            ])
            content2.addAttributes([
                NSFontAttributeName: UIFont(name:"HoeflerText-Black", size:24)!,
                NSExpansionAttributeName: 0.3,
                NSKernAttributeName: -4 // negative kerning bug fixed in iOS 8
                // but they broke it again in iOS 8.3!
            ], range:NSMakeRange(0,1))
            self.lab.attributedText = content2
            self.tv.attributedText = content2
            self.tv.contentInset = UIEdgeInsetsMake(20,0,0,0)
            if which > 2 {fallthrough}
        case 3, 4, 5:
            content2.addAttribute(NSParagraphStyleAttributeName,
                value:lend {
                    (para:NSMutableParagraphStyle) in
                    para.headIndent = 10
                    para.firstLineHeadIndent = 10
                    para.tailIndent = -10
                    para.lineBreakMode = .ByWordWrapping
                    para.alignment = .Justified
                    para.lineHeightMultiple = 1.2
                    para.hyphenationFactor = 1.0
                }, range:NSMakeRange(0,1))
            self.lab.attributedText = content2
            self.tv.attributedText = content2
            self.tv.contentInset = UIEdgeInsetsMake(20,0,0,0)
            if which > 3 {fallthrough}
        case 4, 5:
            let end = content.length
            content.replaceCharactersInRange(NSMakeRange(end, 0), withString:"\n")
            content.appendAttributedString(content2)
            self.lab.attributedText = content
            self.tv.attributedText = content
            self.tv.contentInset = UIEdgeInsetsMake(10,0,0,0)
            if which > 4 {fallthrough}
        case 5:
            // demonstrating efficient cycling through style runs
            let opts : NSAttributedStringEnumerationOptions = .LongestEffectiveRangeNotRequired
            content.enumerateAttribute(NSFontAttributeName,
                inRange:NSMakeRange(0,content.length),
                options:opts,
                usingBlock: {
                    value, range, stop in
                    println(range)
                    let font = value as! UIFont
                    if font.pointSize == 15 {
                        content.addAttribute(NSFontAttributeName,
                            value:UIFont(name: "Arial-BoldMT", size:20)!,
                            range:range)
                    }
                })
            self.lab.attributedText = content
            self.tv.attributedText = content
            self.tv.contentInset = UIEdgeInsetsMake(10,0,0,0)
        default:break
        }
    }
    
    
}
