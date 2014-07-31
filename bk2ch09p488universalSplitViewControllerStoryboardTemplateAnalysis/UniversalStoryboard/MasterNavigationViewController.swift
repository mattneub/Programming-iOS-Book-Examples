

import UIKit

class MasterNavigationViewController : UINavigationController {
    // logging to show how things work
    // the segue sends showDetailViewController
    // by way of "target for"
    // the split view controller implements it, it gets the call...
    
    // when it is expanded, it just shoves the detail view controller into the detail slot
    // but when it is collapsed,
    // it turns around and sends showViewController to the nav controller in the primary!
    // thus it gets pushed onto the stack
    
    override func showViewController(vc: UIViewController!, sender: AnyObject!) {
        println("master NAV view controller showViewController")
        super.showViewController(vc, sender: sender)
    }

}
