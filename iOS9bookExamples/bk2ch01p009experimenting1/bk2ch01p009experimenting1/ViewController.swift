

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        let mainview = self.view
        let v = UIView(frame:CGRectMake(100,100,50,50))
        v.backgroundColor = UIColor.redColor() // small red square
        mainview.addSubview(v) // add it to main view
    }


}

