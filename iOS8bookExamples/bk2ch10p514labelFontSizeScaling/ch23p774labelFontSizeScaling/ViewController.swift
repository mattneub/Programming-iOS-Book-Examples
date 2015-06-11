

import UIKit

class ViewController: UIViewController {
    @IBOutlet var lab : UILabel!
    @IBOutlet var lab2 : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // proving that text font size shrinkage in a label works in a multiline label in iOS 8
        
        let s2 = "Fourscore and seven years ago, our fathers brought forth " +
            "upon this continent a new nation, conceived in liberty and dedicated " +
            "to the proposition that all men are created equal."
        let content2 = NSMutableAttributedString(string:s2, attributes: [
            NSFontAttributeName: UIFont(name:"HoeflerText-Black", size:16)!
        ])
        content2.addAttributes([
            NSFontAttributeName: UIFont(name:"HoeflerText-Black", size:24)!,
            NSKernAttributeName: -4
            ], range:NSMakeRange(0,1))
        
        self.lab.adjustsFontSizeToFitWidth = true
        self.lab.minimumScaleFactor = 0.7
        
        // self.lab.lineBreakMode = .ByWordWrapping
        
        // self.lab.numberOfLines = 1
        
        self.lab.attributedText = content2
        self.lab2.attributedText = content2
        
    }


}
