

import UIKit

class RootViewController : UIViewController {

    @IBAction func unwind(s:UIStoryboardSegue) {
        
    }

    // prove that the segue is not magically called during restoration

    override func prepareForSegue(segue:UIStoryboardSegue, sender:AnyObject?) {
        NSLog("%@", segue.identifier!)
    }

}

class SecondViewController : UIViewController {
    @IBAction func unwind(s:UIStoryboardSegue) {
        
    }
}

class PresentedViewController : UIViewController {
    @IBAction func unwind(s:UIStoryboardSegue) {
        
    }
}

