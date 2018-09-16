

import UIKit

class MyImagePickerController : UIImagePickerController {
    override var prefersStatusBarHidden : Bool {
        return true
    }
    override var childViewControllerForStatusBarHidden : UIViewController? {
        return nil
    }
}
