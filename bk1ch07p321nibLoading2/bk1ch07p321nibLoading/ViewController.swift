

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var v : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let arr = NSBundle.mainBundle().loadNibNamed("View", owner: self, options: nil)
        self.view.addSubview(self.v)

    
    }



}

