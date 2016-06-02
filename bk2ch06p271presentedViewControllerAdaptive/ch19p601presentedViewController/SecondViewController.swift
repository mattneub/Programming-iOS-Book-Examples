

import UIKit

/* 

Standard architecture for handing info from vc to presented vc...
...and back when presented vc is dismissed

*/

protocol SecondViewControllerDelegate : class {
    func accept(data:AnyObject!)
}

class SecondViewController : UIViewController {
    
    var data : AnyObject?
    
    weak var delegate : SecondViewControllerDelegate?
    
    @IBAction func doDismiss(_ sender:AnyObject?) {
        // logging to show relationships
        print(self.presenting!)
        print(self.presenting!.presented)
        let vc = self.delegate as! UIViewController
        print(vc.presented)
        
        
        // just proving it works
        // self.dismiss(animated:true, completion: nil)
        // vc.dismiss(animated:true, completion: nil)
        // return;
        
        self.presenting!.dismiss(animated:true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // prove you've got data
        print(self.data)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isBeingDismissed() {
            self.delegate?.accept(data:"Even more important data!")
        }
    }
    
    
}
