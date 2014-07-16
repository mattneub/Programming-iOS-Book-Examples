

import UIKit

class ViewController : UIViewController, SecondViewControllerDelegate {
    
    @IBAction func doPresent(sender:AnyObject?) {
        let svc = SecondViewController()
        svc.data = "This is very important data!"
        svc.delegate = self
        self.presentViewController(svc, animated:true, completion:nil)
        
    }
    
    func acceptData(data:AnyObject!) {
        // do something with data here
        
        // prove that you received data
        println(data)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        println("vc did disappear")
    }
    
    override func supportedInterfaceOrientations() -> Int  {
        return Int(UIInterfaceOrientationMask.Portrait.toRaw())
    }
    
    override func viewWillLayoutSubviews() {
        println("presenter will layout")
    }
    
    
    
}
