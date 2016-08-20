

import UIKit

class RootViewController : UIViewController {

    @IBAction func unwind(_ seg:UIStoryboardSegue) {
        
    }

    // prove that the segue is not magically called during restoration

    override func prepare(for segue:UIStoryboardSegue, sender:Any?) {
        NSLog("%@", segue.identifier!)
    }

}

class SecondViewController : UIViewController {
    @IBAction func unwind(_ seg:UIStoryboardSegue) {
        
    }
}

class PresentedViewController : UIViewController {
    @IBAction func unwind(_ seg:UIStoryboardSegue) {
        
    }
}

