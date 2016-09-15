

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
    
    
    // could alternatively use an "unwind" segue here
    // I'll show that later
    
    @IBAction func doDismiss(sender:AnyObject?) {
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // prove you've got data
        print(self.data)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isBeingDismissed() {
            self.delegate?.acceptData("Even more important data!")
        }
    }
    
    
}
