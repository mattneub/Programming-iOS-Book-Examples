

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var coolview : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        NSBundle.main().loadNibNamed("View", owner: self)
        self.view.addSubview(self.coolview)

    
    }



}

