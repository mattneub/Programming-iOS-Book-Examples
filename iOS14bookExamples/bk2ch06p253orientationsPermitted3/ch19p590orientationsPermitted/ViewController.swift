
import UIKit

class ViewController : UIViewController {
    
    // all three are now contributing to the story:
    // the plist, the app delegate, and the view controller
    // in iOS 12 and before,
    // they must agree! each level down adds a further filter, as it were
    // if the app delegate says Landscape,
    // the view controller can't say Portrait
    // but there's a huge change in iOS 13 — it doesn't seem to care
    // I guess this is because different windows might want to be allowed
    // to do different things?
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        print("view controller doing whatever it does")
        // used to be that you uncomment next line we'd crash
        // "Supported orientations has no common orientation with the application, and shouldAutorotate is returning YES"
        return .portrait
        // return .landscape
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
