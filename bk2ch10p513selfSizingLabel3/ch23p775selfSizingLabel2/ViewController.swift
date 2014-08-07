

import UIKit
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}
func lend<T where T:NSObject> (closure:(T)->()) -> T {
    let orig = T()
    closure(orig)
    return orig
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
        
        content2.addAttribute(NSParagraphStyleAttributeName,
            value:lend({
                (para2:NSMutableParagraphStyle) in
                para2.headIndent = 10
                para2.firstLineHeadIndent = 10
                para2.tailIndent = -10
                para2.lineBreakMode = .ByWordWrapping
                para2.alignment = .Justified
                para2.lineHeightMultiple = 1.2
                para2.hyphenationFactor = 1.0
            }), range:NSMakeRange(0,1))

        
        self.lab1.attributedText = content2
        self.lab2.preferredMaxLayoutWidth = 250
        self.lab2.attributedText = content2

    }
    
    // a rather desperate solution
    // since the labels are not being notified at layout time,
    // give the job to someone who _is_ being notified at layout time!
    // In this case I've elected to use the view controller,
    // but of course one can think of other candidates
    
    func allSubviews(v:UIView, closure:(UIView) -> ()) {
        let subs = v.subviews as [UIView]
        for sub in subs {
            closure(sub)
            allSubviews(sub, closure:closure)
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.allSubviews(self.view) {
            v in
            if let v = v as? MyLabel {
                v.preferredMaxLayoutWidth = v.bounds.width
            }
        }
    }
}
