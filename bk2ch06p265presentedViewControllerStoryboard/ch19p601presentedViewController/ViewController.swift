

import UIKit

class ViewController : UIViewController, SecondViewControllerDelegate {
    
    // the segue in the storyboard is drawn directly from the button...
    // so SecondViewController will be instantiated for us...
    // and "presentViewController" will be called for us
    // thus we need another place to configure
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "present" { // it will be
            let svc = segue.destinationViewController as! SecondViewController
            svc.data = "This is very important data!"
            svc.delegate = self
        }
    }
    
    func acceptData(data:AnyObject!) {
        // do something with data here
        
        // prove that you received data
        print(data)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("vc did disappear")
    }
    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)!) {
        print("here") // prove that this is called by clicking on curl
        super.dismissViewControllerAnimated(flag, completion: completion)
    }
    
    
}
