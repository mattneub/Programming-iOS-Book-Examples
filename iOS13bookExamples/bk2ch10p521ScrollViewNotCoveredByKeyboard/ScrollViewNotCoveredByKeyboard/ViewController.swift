

import UIKit

// just proving that the user can scroll to dismiss the keyboard
// even if the keyboard isn't covering the scroll view

class ViewController: UIViewController {
    @IBOutlet weak var sv: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sv.contentSize = CGSize(width: 1, height: 400)
    }


}

