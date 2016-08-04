

import UIKit

class MyImagePickerController : UIImagePickerController {
    override var prefersStatusBarHidden : Bool {
        return true
    }
    override func childViewControllerForStatusBarHidden() -> UIViewController? {
        return nil
    }
}
