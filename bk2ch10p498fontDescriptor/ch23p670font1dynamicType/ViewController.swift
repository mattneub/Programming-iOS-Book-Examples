

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
        self.doDynamicType()
    }
        
    override func traitCollectionDidChange(_ ptc: UITraitCollection?) {
        super.traitCollectionDidChange(ptc)
        let tc = self.traitCollection
        if ptc == nil ||
        ptc!.preferredContentSizeCategory != tc.preferredContentSizeCategory {
            // self.doDynamicType() // why is this needed? can't seem to be dynamic without it
            print("here")
        }
    }
    
    func doDynamicType() {
        
        let body = UIFontDescriptor
            .preferredFontDescriptor(withTextStyle:.body)
            .withDesign(.serif)!
        let emphasis = body.withSymbolicTraits(.traitItalic)!
        var fbody = UIFont(descriptor: body, size: 0)
        // work around lack of dynamism; this should not be necessary
        // bug still there in beta 6
        fbody = UIFontMetrics(forTextStyle: .body).scaledFont(for: fbody)
        var femphasis = UIFont(descriptor: emphasis, size: 0)
        // work around lack of dynamism; this should not be necessary
        femphasis = UIFontMetrics(forTextStyle: .body).scaledFont(for: femphasis)
        
        let s = self.lab.text!
        let mas = NSMutableAttributedString(string: s, attributes: [.font:fbody])
        mas.addAttribute(.font, value: femphasis, range: (s as NSString).range(of:"wild"))
        self.lab.attributedText = mas
        
    }
    
}
