

import UIKit

class MyImagePickerController: UIImagePickerController {
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return self.presentingViewController!.supportedInterfaceOrientations
    }

}
