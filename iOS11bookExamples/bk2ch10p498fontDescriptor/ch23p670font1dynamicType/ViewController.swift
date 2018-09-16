

import UIKit

class ViewController : UIViewController {
    @IBOutlet var lab : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lab.adjustsFontForContentSizeCategory = true
        
        let f = UIFont(name: "Avenir", size: 15)!
        let desc = f.fontDescriptor
        let desc2 = desc.withSymbolicTraits(.traitItalic)
        let f2 = UIFont(descriptor: desc2!, size: 0)
        print(f)
        print(desc)
        print(desc2 as Any)
        print(f2)
    }
    
    override func traitCollectionDidChange(_ ptc: UITraitCollection?) {
        let tc = self.traitCollection
        if ptc == nil ||
        ptc!.preferredContentSizeCategory != tc.preferredContentSizeCategory {
            self.doDynamicType()
        }
    }
    
    func doDynamicType() {
        var fbody : UIFont!
        var femphasis : UIFont!
        
        let body = UIFontDescriptor.preferredFontDescriptor(withTextStyle:.body)
        let emphasis = body.withSymbolicTraits(.traitItalic)!
        fbody = UIFont(descriptor: body, size: 0)
        femphasis = UIFont(descriptor: emphasis, size: 0)
        print(fbody)
        
        let s = self.lab.text!
        let mas = NSMutableAttributedString(string: s, attributes: [.font:fbody])
        mas.addAttribute(.font, value: femphasis, range: (s as NSString).range(of:"wild"))
        self.lab.attributedText = mas
        
    }
    
}
