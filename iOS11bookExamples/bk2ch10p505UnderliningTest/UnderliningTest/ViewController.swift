

import UIKit
import Swift

class ViewController: UIViewController {
    @IBOutlet weak var lab: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

//        let mas = NSMutableAttributedString(string: "Buy beer", attributes: [
//            .underlineStyle: NSUnderlineStyle.StyleNone.rawValue
//            ])
        
        let mas = NSMutableAttributedString(string: "Buy beer")

        // this didn't work in iOS 8 until it was fixed in iOS 8.3
//        mas.addAttributes([
//            .underlineStyle: NSUnderlineStyle.StyleSingle.rawValue
//            ], range: NSMakeRange(4, mas.length-4))
    
        // showing that it is necessary to use freaking bitwise-or to form this bitmask still
        let under = NSUnderlineStyle.styleThick.rawValue | NSUnderlineStyle.patternDash.rawValue
        mas.addAttributes([
            .underlineStyle: under
            ], range: NSMakeRange(4, mas.length-4))

        
        self.lab.attributedText = mas
    
    }



}

