
import UIKit

class ViewController : UIViewController {
    
    // all three are now contributing to the story:
    // the plist, the app delegate, and the view controller
    // but they must agree! each level down adds a further filter, as it were
    // if the app delegate says Landscape,
    // the view controller can't say Portrait
    
    override func supportedInterfaceOrientations() -> Int {
        // uncomment next line to crash
        // "Supported orientations has no common orientation with the application, and shouldAutorotate is returning YES"
        // return Int(UIInterfaceOrientationMask.Portrait.rawValue)
        return Int(UIInterfaceOrientationMask.LandscapeRight.rawValue)
    }
    
}
