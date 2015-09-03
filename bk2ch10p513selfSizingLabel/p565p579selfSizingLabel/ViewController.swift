

import UIKit

func lend<T where T:NSObject> (closure:(T)->()) -> T {
    let orig = T()
    closure(orig)
    return orig
}

class ViewController : UIViewController {
    @IBOutlet var theLabel : UILabel!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let showTheBug = true // set to true and run on iPhone 4s to see the bug
        switch showTheBug {
        case true:
            let att = self.theLabel.attributedText!.mutableCopy() as! NSMutableAttributedString
            att.addAttribute(NSParagraphStyleAttributeName,
                value: lend {
                    (para : NSMutableParagraphStyle) in
                    para.headIndent = 20;
                    para.firstLineHeadIndent = 20
                    para.tailIndent = -20
                } ,
                range:NSMakeRange(0,1))
            self.theLabel.attributedText = att

        default:break
        }

        self.theLabel.sizeToFit()
        
    }
    
}
