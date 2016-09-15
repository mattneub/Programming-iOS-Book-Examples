

import UIKit

class MyImagePickerController : UIImagePickerController {
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func childViewControllerForStatusBarHidden() -> UIViewController? {
        return nil
    }
}
