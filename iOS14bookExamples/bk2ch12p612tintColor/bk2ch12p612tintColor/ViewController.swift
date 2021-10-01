

import UIKit

class ViewController: UIViewController {

    var blue = true
    
    @IBAction func doToggleTint(_ sender: Any) {
        self.blue = !self.blue
        self.view.window?.tintColor = self.blue ? nil : UIColor.red
    }
    
    var dim = false

    @IBAction func doToggleDimming(_ sender: Any) {
        self.dim = !self.dim
        self.view.tintAdjustmentMode = self.dim ? .dimmed : .automatic
    }
    
}

