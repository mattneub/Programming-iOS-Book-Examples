

import UIKit

class MyImagePickerController : UIImagePickerController {
    override var prefersStatusBarHidden : Bool {
        return true
    }
    override var childForStatusBarHidden : UIViewController? {
        return nil
    }
}
