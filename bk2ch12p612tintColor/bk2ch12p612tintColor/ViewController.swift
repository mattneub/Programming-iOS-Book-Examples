

import UIKit

class ViewController: UIViewController {

    var blue = true
    
    @IBAction func doToggleTint(_ sender: AnyObject) {
        self.blue = !self.blue
        self.view.tintColor = self.blue ? nil : UIColor.red
    }
    
    var dim = false

    @IBAction func doToggleDimming(_ sender: AnyObject) {
        self.dim = !self.dim
        self.view.tintAdjustmentMode = self.dim ? .dimmed : .automatic
    }
    
}

