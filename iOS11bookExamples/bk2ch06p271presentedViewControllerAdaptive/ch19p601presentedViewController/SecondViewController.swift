

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
    
    @IBAction func doDismiss(_ sender: Any?) {
        // logging to show relationships
        print(self.presentingViewController!)
        print(self.presentingViewController!.presentedViewController as Any)
        let vc = self.delegate as! UIViewController
        print(vc.presentedViewController as Any)
        
        
        // just proving it works
        // self.dismiss(animated:true)
        // vc.dismiss(animated:true)
        // return;
        
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
