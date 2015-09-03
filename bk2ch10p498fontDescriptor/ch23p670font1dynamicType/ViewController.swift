

import UIKit
import CoreText

class ViewController : UIViewController {
    @IBOutlet var lab : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doDynamicType(nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "doDynamicType:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        let f = UIFont(name: "Avenir", size: 15)!
        let desc = f.fontDescriptor()
        let desc2 = desc.fontDescriptorWithSymbolicTraits(.TraitItalic)
        let f2 = UIFont(descriptor: desc2, size: 0)
        print(f)
        print(desc)
        print(desc2)
        print(f2)
    }
    
    let which = 1

    func doDynamicType(n:NSNotification!) {
        var fbody : UIFont!
        var femphasis : UIFont!
        switch which {
        case 1:
            let body = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody)
            let emphasis = body.fontDescriptorWithSymbolicTraits(.TraitItalic)
            fbody = UIFont(descriptor: body, size: 0)
            femphasis = UIFont(descriptor: emphasis, size: 0)
            print(fbody)
        case 2:
            // starting in iOS 8.3, this works
            let body = UIFont(name: "GillSans", size: 15)!
            let emphasis = body.fontDescriptor().fontDescriptorWithSymbolicTraits(.TraitItalic)
            fbody = body
            femphasis = UIFont(descriptor: emphasis, size: 0)
        case 3:
            // the workaround in iOS 8.2 and before is drop down to Core Text
            let body = UIFont(name: "GillSans", size: 15)!
            let result = CTFontCreateCopyWithSymbolicTraits(body as CTFont, 0, nil, .ItalicTrait, .ItalicTrait)!
            fbody = body
            femphasis = result as UIFont
        default:break
        }
        
        let s = self.lab.text!
        let mas = NSMutableAttributedString(string: s, attributes: [NSFontAttributeName:fbody])
        mas.addAttribute(NSFontAttributeName, value: femphasis, range: (s as NSString).rangeOfString("wild"))
        self.lab.attributedText = mas
    }
    
}