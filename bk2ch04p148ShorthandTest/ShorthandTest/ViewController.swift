

import UIKit

class ViewController: UIViewController {
    
    let lay = CALayer()
    var timer : Timer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        lay.frame = CGRect(x: 150, y: 50, width: 50, height: 50)
        lay.backgroundColor = UIColor.red.cgColor
        self.view.layer.addSublayer(lay)
    }
    
    // demonstrating that if you use the shorthand where you give neither
    // toValue nor fromValue, the presentation layer keeps reflecting the final value
    @IBAction func doButton1(_ sender: Any) {
        lay.bounds.size.width = 200
        let anim = CABasicAnimation(keyPath: "bounds.size.width")
        anim.duration = 10
        lay.add(anim, forKey: nil)
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            print(self.lay.bounds, self.lay.presentation()!.bounds)
        }
    }
    
    
}


