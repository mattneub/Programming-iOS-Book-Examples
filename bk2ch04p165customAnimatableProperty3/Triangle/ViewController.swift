

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var triangleView: TriangleView!
    
    
    @IBAction func doButton(_ sender: UIButton) {
        
        CATransaction.setAnimationDuration(1)
        CATransaction.setCompletionBlock({sender.isEnabled = true})
        sender.isEnabled = false
        self.triangleView.v1x = (self.triangleView.v1x == 200) ? 0 : 200
        
    }
}

