

import UIKit

class ViewController: UIViewController {

    @IBOutlet var mv : MyMandelbrotView!
    
    @IBAction func doButton (_ sender:AnyObject!) {
        self.mv.drawThatPuppy()
    }

    
}
