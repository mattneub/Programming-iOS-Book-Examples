

import UIKit

class MyImagePickerController: UIImagePickerController {
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return self.presenting!.supportedInterfaceOrientations()
    }

}
