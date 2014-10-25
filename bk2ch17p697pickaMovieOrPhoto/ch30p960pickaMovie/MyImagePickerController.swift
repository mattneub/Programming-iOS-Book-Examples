

import UIKit

class MyImagePickerController: UIImagePickerController {
    
    override func supportedInterfaceOrientations() -> Int {
        return self.presentingViewController!.supportedInterfaceOrientations()
    }

}
