

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lab1: UILabel!
    @IBOutlet weak var lab2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let s = "This is a test"
        let mas1 = NSAttributedString(string: s, attributes: [
            .font:UIFont(name: "Georgia", size: 16)!
        ])
        let tracking : NSAttributedString.Key = {
            if #available(iOS 14.0, *) {
                return .tracking
            } else {
                return kCTTrackingAttributeName as NSAttributedString.Key
            }
        }()
        let mas2 = NSAttributedString(string: s, attributes: [
            .font:UIFont(name: "Georgia", size: 16)!,
            tracking: -0.2
        ])
        
        self.lab1.attributedText = mas1
        self.lab2.attributedText = mas2
        
        let color = mas1.attribute(.foregroundColor, at: 0, effectiveRange: nil)
        print(color as Any) // nil, but we are evidently using `.label` by default
    }


}

