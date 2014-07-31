

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
        let which = 3
        switch which {
        case 1:
            let body = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody)
            let emphasis = body.fontDescriptorWithSymbolicTraits(.TraitItalic)
            fbody = UIFont(descriptor: body, size: 0)
            femphasis = UIFont(descriptor: emphasis, size: 0)
        case 2:
            // this should work but doesn't (bug?)
            fbody = UIFont(name: "GillSans", size: 15)
            let emphasis = fbody.fontDescriptor().fontDescriptorWithSymbolicTraits(.TraitItalic)
            femphasis = UIFont(descriptor: emphasis, size: 0)
        case 3:
            // the workaround is drop down to Core Text
            // unfortunately Swift seems unaware that CTFont and UIFont are now bridged
            fbody = UIFont(name: "GillSans", size: 15)
            // see AppDelegate.m for category methods I created to cross the bridge
            let result = CTFontCreateCopyWithSymbolicTraits(fbody.toCTFont().takeRetainedValue(), 0, nil, CTFontSymbolicTraits.ItalicTrait, CTFontSymbolicTraits.ItalicTrait)
            femphasis = UIFont.fromCTFont(result)
        default:break
        }
        
        let s = self.lab.text as NSString
        let mas = NSMutableAttributedString(string: s, attributes: [NSFontAttributeName:fbody])
        mas.addAttribute(NSFontAttributeName, value: femphasis, range: s.rangeOfString("wild"))
        self.lab.attributedText = mas
    }

}