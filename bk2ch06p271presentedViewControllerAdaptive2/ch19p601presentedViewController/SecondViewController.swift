

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
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print(self.view.bounds.size.width, appendNewline:false)
        print("\t", appendNewline:false)
        print(self.view.bounds.size.height, appendNewline:false)
        print("\t", appendNewline:false)

        print(self.view.backgroundColor!)


    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isBeingDismissed() {
            self.delegate?.acceptData("Even more important data!")
        }
    }
    
    
}
