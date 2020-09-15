
import UIKit

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}

class ViewController : UIViewController {
    override func viewDidAppear(_ animated: Bool)  {
        super.viewDidAppear(animated)
        print(self.view.window!)
        print(UIApplication.shared.delegate!.window!!) // kind of wacky, there, Swift
        print((UIApplication.shared.delegate as! AppDelegate).window!)
        print(UIApplication.shared.keyWindow!)
        print(UIApplication.shared.windows.count) // prove there's just the one, ours
    }
    
    // for end of chapter 5 example
    
    override func viewDidLoad() {
        let lay1 = CALayer()
        lay1.backgroundColor = UIColor(red: 1.0, green: 0.4, blue: 1, alpha: 1).cgColor
        lay1.frame = CGRect(113, 111, 132, 194)
        self.view.layer.addSublayer(lay1)
        let lay2 = CALayer()
        lay2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1).cgColor
        lay2.frame = CGRect(41, 56, 132, 194)
        lay1.addSublayer(lay2)
        let lay3 = CALayer()
        lay3.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1).cgColor
        lay3.frame = CGRect(43, 197, 160, 230)
        self.view.layer.addSublayer(lay3)
    }
}
