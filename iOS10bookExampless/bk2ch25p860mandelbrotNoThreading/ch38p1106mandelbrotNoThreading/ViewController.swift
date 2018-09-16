

import UIKit

class ViewController: UIViewController {

    @IBOutlet var mv : MyMandelbrotView!
    
    @IBAction func doButton (_ sender: Any!) {
        self.mv.drawThatPuppy()
    }

    
}
