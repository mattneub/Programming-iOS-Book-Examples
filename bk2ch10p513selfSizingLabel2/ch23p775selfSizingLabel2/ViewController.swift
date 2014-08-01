

import UIKit
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class ViewController : UIViewController {
    @IBOutlet var lab1 : UILabel!
    @IBOutlet var lab2 : UILabel!
    
    // rotate for full effect
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        delay(2) {
            self.doYourThing()
        }
    }
    
    func doYourThing() {
        
        let s2 = "Fourscore and seven years ago, our fathers brought forth " +
            "upon this continent a new nation, conceived in liberty and dedicated " +
        "to the proposition that all men are created equal."
        let content2 = NSMutableAttributedString(string:s2, attributes: [
            NSFontAttributeName: UIFont(name:"HoeflerText-Black", size:16)
            ])
        content2.addAttributes([
            NSFontAttributeName: UIFont(name:"HoeflerText-Black", size:24),
            NSExpansionAttributeName: 0.3,
            NSKernAttributeName: -4 // negative kerning bug fixed in iOS 8
            ], range:NSMakeRange(0,1))
        
        let para2 = NSMutableParagraphStyle()
        para2.headIndent = 10
        para2.firstLineHeadIndent = 10
        para2.tailIndent = -10
        para2.lineBreakMode = .ByWordWrapping
        para2.alignment = .Justified
        para2.lineHeightMultiple = 1.2
        para2.hyphenationFactor = 1.0
        content2.addAttribute(NSParagraphStyleAttributeName,
            value:para2, range:NSMakeRange(0,1))

        
        self.lab1.attributedText = content2
        self.lab2.preferredMaxLayoutWidth = 250
        self.lab2.attributedText = content2

    }
}
