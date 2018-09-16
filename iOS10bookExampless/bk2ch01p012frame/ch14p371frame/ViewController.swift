

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let v1 = UIView(frame:CGRect(113, 111, 132, 194))
        v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
        let v2 = UIView(frame:CGRect(41, 56, 132, 194))
        v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
        let v3 = UIView(frame:CGRect(43, 197, 160, 230))
        v3.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        
        self.view.addSubview(v1)
        v1.addSubview(v2)
        self.view.addSubview(v3)


    }


}
