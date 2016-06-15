

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
        print(self.presentingViewController!)
        print(self.presentingViewController!.presentedViewController)
        let vc = self.delegate as! UIViewController
        print(vc.presentedViewController)
        
        
        // just proving it works
        // self.dismiss(animated:true)
        // vc.dismiss(animated:true)
        // return;
        
        self.presentingViewController!.dismiss(animated:true)
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("new size coming: \(size)")
    }
    
    
}
