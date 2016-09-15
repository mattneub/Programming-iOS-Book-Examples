

import UIKit

class MyImagePickerController: UIImagePickerController {
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return self.presentingViewController!.supportedInterfaceOrientations()
    }

}
