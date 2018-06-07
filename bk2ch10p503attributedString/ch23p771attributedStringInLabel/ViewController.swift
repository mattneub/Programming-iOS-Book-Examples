
import UIKit

// useful little utility for encapsulation of "lend me" objects like
// NSMutableParagraphStyle and NSShadow

func lend<T> (closure:(T)->()) -> T where T:NSObject {
    let orig = T()
    closure(orig)
    return orig
}

class ViewController : UIViewController {
    
    @IBOutlet var lab : UILabel!
    @IBOutlet var tv : UITextView!
    
    let which = 4 // 0 ... 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.tv.textContainer.lineFragmentPadding = 0 // make it just like the label
        // to show that under identical conditions they do draw identically
        
        self.tv.isScrollEnabled = false // in case setting in the nib doesn't work
        
        var content : NSMutableAttributedString!
        var content2 : NSMutableAttributedString!
        
        switch which { // ignore incredibly annoying warnings from compiler
        case 0, 1, 4, 5:
            let s1 = """
                The Gettysburg Address, as delivered on a certain occasion \
                (namely Thursday, November 19, 1863) by A. Lincoln
                """
            content = NSMutableAttributedString(string:s1, attributes:[
                .font: UIFont(name:"Arial-BoldMT", size:15)!,
                .foregroundColor: UIColor(red:0.251, green:0.000, blue:0.502, alpha:1)
                ])
            let r = (content.string as NSString).range(of:"Gettysburg Address")
            content.addAttributes([
                .strokeColor: UIColor.red,
                .strokeWidth: -2.0
                ], range: r)
            self.lab.attributedText = content
            self.tv.attributedText = content
            self.tv.textContainerInset = UIEdgeInsets(top: 30,left: 0,bottom: 0,right: 0)
            if which > 0 {fallthrough}
        case 1, 4, 5:
            let para = NSMutableParagraphStyle()
            para.headIndent = 10
            para.firstLineHeadIndent = 10
            para.tailIndent = -10
            para.lineBreakMode = .byWordWrapping
            para.alignment = .center
            para.paragraphSpacing = 15
            content.addAttribute(
                .paragraphStyle,
                value:para, range:NSMakeRange(0,1))
            self.lab.attributedText = content
            self.tv.attributedText = content
            self.tv.textContainerInset = UIEdgeInsets(top: 30,left: 0,bottom: 0,right: 0)
            if which >= 4 {fallthrough}
        case 2, 3, 4, 5:
            let s2 = """
                Fourscore and seven years ago, our fathers brought forth \
                upon this continent a new nation, conceived in liberty and \
                dedicated to the proposition that all men are created equal.
                """
            content2 = NSMutableAttributedString(string:s2, attributes: [
                .font: UIFont(name:"HoeflerText-Black", size:16)!
                ])
            content2.addAttributes([
                .font: UIFont(name:"HoeflerText-Black", size:24)!,
                .expansion: 0.3,
                .kern: -4 // negative kerning bug fixed in iOS 8
                // but they broke it again in iOS 8.3!
                // but they fixed it again in iOS 9!
                ], range:NSMakeRange(0,1))
            self.lab.attributedText = content2
            self.tv.attributedText = content2
            self.tv.textContainerInset = UIEdgeInsets(top: 30,left: 0,bottom: 0,right: 0)
            if which > 2 {fallthrough}
        case 3, 4, 5:
            content2.addAttribute(.paragraphStyle,
                                  value:lend {
                                    (para:NSMutableParagraphStyle) in
                                    para.headIndent = 10
                                    para.firstLineHeadIndent = 10
                                    para.tailIndent = -10
                                    para.lineBreakMode = .byWordWrapping
                                    para.alignment = .justified
                                    para.lineHeightMultiple = 1.2
                                    para.hyphenationFactor = 1.0
            }, range:NSMakeRange(0,1))
            self.lab.attributedText = content2
            self.tv.attributedText = content2
            self.tv.textContainerInset = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)
            if which > 3 {fallthrough}
        case 4, 5:
            let end = content.length
            content.replaceCharacters(in:NSMakeRange(end, 0), with:"\n")
            content.append(content2)
            self.lab.attributedText = content
            self.tv.attributedText = content
            self.tv.textContainerInset = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)
            
            // need this for a different book example
            var range : NSRange = NSMakeRange(0,0)
            let d = content.attributes(at:content.length-1, effectiveRange:&range)
            print(range)
            print(d)
            _ = d
            
            if which > 4 {fallthrough}
        case 5:
            // demonstrating efficient cycling through style runs
            
            content.enumerateAttribute(.font,
                                       in:NSMakeRange(0,content.length),
                                       options:.longestEffectiveRangeNotRequired) {
                                        value, range, stop in
                                        print(range)
                                        let font = value as! UIFont
                                        if font.pointSize == 15 {
                                            content.addAttribute(.font,
                                                                 value:UIFont(name: "Arial-BoldMT", size:20)!,
                                                                 range:range)
                                        }
            }
            self.lab.attributedText = content
            self.tv.attributedText = content
            self.tv.textContainerInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        default:break
        }
    }
    
    
}
