

import UIKit

class ViewController: UIViewController {

    var blue = true
    
    @IBAction func doToggleTint(sender: AnyObject) {
        self.blue = !self.blue
        self.view.tintColor = self.blue ? nil : UIColor.redColor()
    }
    
    var dim = false

    @IBAction func doToggleDimming(sender: AnyObject) {
        self.dim = !self.dim
        self.view.tintAdjustmentMode = self.dim ? .Dimmed : .Automatic
    }
    
}

