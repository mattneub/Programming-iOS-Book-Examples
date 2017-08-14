

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let v1 = UIView(frame:CGRect(100, 111, 132, 194))
        v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
        let v2 = UIView(frame:CGRect(0, 0, 132, 10))
        v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
        let v1b = v1.bounds
        let v3 = UIView(frame:CGRect(v1b.width-20, v1b.height-20, 20, 20))
        v3.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        self.view.addSubview(v1)
        v1.addSubview(v2)
        v1.addSubview(v3)
        
        v2.autoresizingMask = .flexibleWidth
        v3.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        
        
        delay(2) {
            v1.bounds.size.width += 40
            v1.bounds.size.height -= 50
            //            v1.frame = self.view.bounds
            //            v1.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            print(v2)
            print(v3)
        }
        

        
    }


}
