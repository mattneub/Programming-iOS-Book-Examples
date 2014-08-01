

import UIKit

class ViewController : UIViewController {
    @IBOutlet var theLabel : UILabel!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let showTheBug = false
        switch showTheBug {
        case false:
            let para = NSMutableParagraphStyle()
            para.headIndent = 20;
            para.firstLineHeadIndent = 20
            para.tailIndent = -20
            let att = self.theLabel.attributedText.mutableCopy() as NSMutableAttributedString
            att.addAttribute(NSParagraphStyleAttributeName, value:para, range:NSMakeRange(0,1))
            self.theLabel.attributedText = att

        default:break
        }

        
        self.theLabel.sizeToFit()
    }
    
}
