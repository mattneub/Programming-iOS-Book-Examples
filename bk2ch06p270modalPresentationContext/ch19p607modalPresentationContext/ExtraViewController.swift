

import UIKit

class ExtraViewController : UIViewController {
        
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(self.traitCollection)
    }
    
    @IBAction func doButton (_ sender: Any) {
        print("presented vc's presenting vc: \(self.presentingViewController as Any)")
        self.presentingViewController?.dismiss(animated:true)
    }
}
