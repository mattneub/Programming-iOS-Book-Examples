

import UIKit

class ExtraViewController : UIViewController {
        
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func doButton (_ sender: AnyObject) {
        print("presented vc's presenting vc: \(self.presentingViewController)")
        self.presentingViewController!.dismiss(animated:true)
    }
}
