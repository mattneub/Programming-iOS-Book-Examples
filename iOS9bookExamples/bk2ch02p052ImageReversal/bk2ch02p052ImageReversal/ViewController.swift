

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var iv: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.iv.image = self.iv.image?.imageFlippedForRightToLeftLayoutDirection()
    }


}

