

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let arr = Bundle.main.loadNibNamed("View", owner:nil)! // can omit `options:`!
        let v = arr[0] as! UIView
        self.view.addSubview(v)

    
    }



}

