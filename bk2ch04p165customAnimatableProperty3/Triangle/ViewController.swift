

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var triangleView: TriangleView!
    
    
    @IBAction func doButton(sender: UIButton) {
        
        CATransaction.setAnimationDuration(1)
        CATransaction.setCompletionBlock({sender.enabled = true})
        sender.enabled = false
        self.triangleView.v1x = (self.triangleView.v1x == 200) ? 0 : 200
        
    }
}

