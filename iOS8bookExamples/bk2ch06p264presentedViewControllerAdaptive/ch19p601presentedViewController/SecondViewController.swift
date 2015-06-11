

import UIKit

/* 

Standard architecture for handing info from vc to presented vc...
...and back when presented vc is dismissed

*/

protocol SecondViewControllerDelegate : class {
    func acceptData(data:AnyObject!)
}

class SecondViewController : UIViewController {
    
    var data : AnyObject?
    
    weak var delegate : SecondViewControllerDelegate?
    
    @IBAction func doDismiss(sender:AnyObject?) {
        // logging to show relationships
        println(self.presentingViewController!)
        println(self.presentingViewController!.presentedViewController)
        var vc = self.delegate! as AnyObject as! UIViewController
        println(vc.presentedViewController)
        
        
        // just proving it works
        // self.dismissViewControllerAnimated(true, completion: nil)
        // vc.dismissViewControllerAnimated(true, completion: nil)
        // return;
        
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // prove you've got data
        println(self.data)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isBeingDismissed() {
            self.delegate?.acceptData("Even more important data!")
        }
    }
    
    
}
