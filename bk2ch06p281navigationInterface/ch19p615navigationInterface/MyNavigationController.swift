

import UIKit

class MyNavigationController: UINavigationController {

//    override var preferredStatusBarStyle : UIStatusBarStyle {
//        return .lightContent
//    }
    
    override var childForStatusBarStyle : UIViewController? {
        return self.topViewController
    }

}
