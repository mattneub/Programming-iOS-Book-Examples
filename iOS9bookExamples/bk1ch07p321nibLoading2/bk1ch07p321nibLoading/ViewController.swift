

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var coolview : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        NSBundle.mainBundle().loadNibNamed("View", owner: self, options: nil)
        self.view.addSubview(self.coolview)

    
    }



}

