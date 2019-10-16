
import UIKit

class ViewController : UIViewController {
    
    // all three are now contributing to the story:
    // the plist, the app delegate, and the view controller
    // but they must agree! each level down adds a further filter, as it were
    // if the app delegate says Landscape,
    // the view controller can't say Portrait
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        // uncomment next line to crash
        // "Supported orientations has no common orientation with the application, and shouldAutorotate is returning YES"
        // return .portrait
        return .landscapeRight
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
