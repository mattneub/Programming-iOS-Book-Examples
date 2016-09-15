

import UIKit

class RootViewController : UIViewController {
    
    // we are getting our view from a nib, but we could alternatively create it in `loadView`
    // or create a generic view and populate it in `viewDidLoad`
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.view)
    }
    
}
