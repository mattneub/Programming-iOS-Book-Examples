

import UIKit
import CoreText

class ViewController : UIViewController {
    @IBOutlet var lab : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doDynamicType(nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "doDynamicType:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    func doDynamicType(n:NSNotification!) {
        var fbody : UIFont!
        var femphasis : UIFont!
        let which = 1
        switch which {
        case 1:
            let body = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody)
            if let emphasis = body.fontDescriptorWithSymbolicTraits(.TraitItalic) {
                fbody = UIFont(descriptor: body, size: 0)
                femphasis = UIFont(descriptor: emphasis, size: 0)
            }
        case 2:
            // this should work but doesn't (bug?), and we crash later
            // whoa, in iOS 8.3 it works!
            if let body = UIFont(name: "GillSans", size: 15),
                emphasis = body.fontDescriptor().fontDescriptorWithSymbolicTraits(.TraitItalic) {
                    fbody = body
                    femphasis = UIFont(descriptor: emphasis, size: 0)
            }
        case 3:
            // the workaround is drop down to Core Text
            // unfortunately Swift seems unaware that CTFont and UIFont are now bridged
            // whoa, in Swift 1.2 it has heard about this!
            if let body = UIFont(name: "GillSans", size: 15),
                result = CTFontCreateCopyWithSymbolicTraits(body as CTFont, 0, nil, .ItalicTrait, .ItalicTrait) {
                    fbody = body
                    femphasis = result as UIFont
            }
        default:break
        }
        
        let s = self.lab.text!
        let mas = NSMutableAttributedString(string: s, attributes: [NSFontAttributeName:fbody])
        mas.addAttribute(NSFontAttributeName, value: femphasis, range: (s as NSString).rangeOfString("wild"))
        self.lab.attributedText = mas
    }
    
}