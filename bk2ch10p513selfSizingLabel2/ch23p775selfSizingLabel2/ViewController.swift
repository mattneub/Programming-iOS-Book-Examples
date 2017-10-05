

import UIKit
func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}
func lend<T> (closure:(T)->()) -> T where T:NSObject {
    let orig = T()
    closure(orig)
    return orig
}

class ViewController : UIViewController {
    @IBOutlet var lab1 : UILabel! // normal; width constrained absolutely, height adjusts automatically
    @IBOutlet var lab2 : UILabel! // MyLabel; set up in the nib to adjust automatically, the label subclass is no longer needed in iOS 8
    
    // rotate for full effect
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delay(2) {
            self.doYourThing()
        }
    }
    
    func doYourThing() {
        
		let s2 = """
			Fourscore and seven years ago, our fathers brought forth \
			upon this continent a new nation, conceived in liberty and \
			dedicated to the proposition that all men are created equal.
			"""
        let content2 = NSMutableAttributedString(string:s2, attributes: [
            .font: UIFont(name:"HoeflerText-Black", size:16)!
            ])
        content2.addAttributes([
            .font: UIFont(name:"HoeflerText-Black", size:24)!,
            .expansion: 0.3,
            .kern: -4 // negative kerning bug fixed in iOS 8, broken again in iOS 8.3
            ], range:NSMakeRange(0,1))
        
        content2.addAttribute(.paragraphStyle,
            value: lend {
                (para : NSMutableParagraphStyle) in
                para.headIndent = 10
                para.firstLineHeadIndent = 10
                para.tailIndent = -10
                para.lineBreakMode = .byWordWrapping
                para.alignment = .justified
                para.lineHeightMultiple = 1.2
                para.hyphenationFactor = 1.0
            },
            range:NSMakeRange(0,1))
        
        self.lab1.attributedText = content2
        self.lab2.attributedText = content2

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition:nil) {
            _ in
            print(self.lab1.preferredMaxLayoutWidth)
            print(self.lab2.preferredMaxLayoutWidth)
        }

    }
}
