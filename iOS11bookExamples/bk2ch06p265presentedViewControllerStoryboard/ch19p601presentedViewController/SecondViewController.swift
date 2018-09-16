

import UIKit

/* 

Standard architecture for handing info from vc to presented vc...
...and back when presented vc is dismissed

*/

protocol SecondViewControllerDelegate : class {
    func accept(data:Any!)
}

class SecondViewController : UIViewController {
    
    var data : Any?
    
    weak var delegate : SecondViewControllerDelegate?
    
    
    // could alternatively use an "unwind" segue here
    // I'll show that later
    
    @IBAction func doDismiss(_ sender: Any?) {
        self.presentingViewController?.dismiss(animated:true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // prove you've got data
        print(self.data as Any)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isBeingDismissed {
            self.delegate?.accept(data:"Even more important data!")
        }
    }
    
    
}
