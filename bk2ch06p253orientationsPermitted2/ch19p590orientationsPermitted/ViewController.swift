

import UIKit

class ViewController : UIViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //print("transition to size", size)
        NSLog("transition to size %@", NSCoder.string(for: size))
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        // print("transition to tc", newCollection)
        NSLog("transition to tc %@ from %@", newCollection, self.traitCollection)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        NSLog("trait collection changed")
    }
}
