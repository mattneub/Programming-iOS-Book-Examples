
import UIKit

class ViewController: UIViewController {
    
    var content = NSMutableAttributedString()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    func imperative() {
        
        let para = NSMutableParagraphStyle()
        para.headIndent = 10
        para.firstLineHeadIndent = 10
        // ... more configuration of para ...
        content.addAttribute(
            NSParagraphStyleAttributeName,
            value:para, range:NSMakeRange(0,1))
        
    }
    
    func functional() {
        
        content.addAttribute(
            NSParagraphStyleAttributeName,
            value: {
                let para = NSMutableParagraphStyle()
                para.headIndent = 10
                para.firstLineHeadIndent = 10
                // ... more configuration of para ...
                return para
                }(),
            range:NSMakeRange(0,1))
        
    }


}

