

import UIKit

class ViewController : UIViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        print("supported in the view controller")
        return .all
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //print("transition to size", size)
        NSLog("transition to size %@", NSCoder.string(for: size))
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        // print("transition to tc", newCollection)
        NSLog("transition to tc %@ from %@", newCollection, self.traitCollection)
        super.willTransition(to: newCollection, with: coordinator)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        NSLog("trait collection changed")
        super.traitCollectionDidChange(previousTraitCollection)
    }
}
