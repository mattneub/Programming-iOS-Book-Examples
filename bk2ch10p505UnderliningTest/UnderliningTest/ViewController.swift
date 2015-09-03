

import UIKit
import Swift

class ViewController: UIViewController {
    @IBOutlet weak var lab: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

//        let mas = NSMutableAttributedString(string: "Buy beer", attributes: [
//            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleNone.rawValue
//            ])
        
        let mas = NSMutableAttributedString(string: "Buy beer")

        // this didn't work in iOS 8 until it was fixed in iOS 8.3
//        mas.addAttributes([
//            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue
//            ], range: NSMakeRange(4, mas.length-4))
    
        // showing that it is necessary to use freaking bitwise-or to form this bitmask still
        mas.addAttributes([
            NSUnderlineStyleAttributeName:
                NSUnderlineStyle.StyleThick.rawValue | NSUnderlineStyle.PatternDash.rawValue
            ], range: NSMakeRange(4, mas.length-4))

        
        self.lab.attributedText = mas
    
    }



}

