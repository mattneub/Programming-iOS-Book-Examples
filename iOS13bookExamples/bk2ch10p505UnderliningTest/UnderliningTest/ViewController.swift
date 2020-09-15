

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
    
        let under : NSUnderlineStyle = [.thick, .patternDash]
        mas.addAttributes([
            .underlineStyle: under.rawValue
            ], range: NSMakeRange(4, mas.length-4))

        
        self.lab.attributedText = mas
    
    }



}

