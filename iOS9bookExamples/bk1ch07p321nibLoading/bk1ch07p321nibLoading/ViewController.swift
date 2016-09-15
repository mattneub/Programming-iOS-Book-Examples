

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let arr = NSBundle.mainBundle().loadNibNamed("View", owner: nil, options: nil)
        let v = arr[0] as! UIView
        self.view.addSubview(v)

    
    }



}

