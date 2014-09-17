

import UIKit

class ViewController : UIViewController, SecondViewControllerDelegate {
    
    @IBAction func doPresent(sender:AnyObject?) {
        
        // logging to prove these are normally nil
        println(self.presentingViewController)
        println(self.presentedViewController)
        
        
        let which = 1
        
        let svc = SecondViewController(nibName: "SecondViewController", bundle: nil)
        svc.data = "This is very important data!"
        svc.delegate = self
        
        switch which {
        case 1: break
        case 2: svc.modalTransitionStyle = .PartialCurl
            // partial curl is not partial in iOS 8; bug?
            // thus, the "click to dismiss" feature makes no sense
            // user taps background and presented vc just dismisses? weird; bug?
        case 3:
            svc.modalTransitionStyle = .FlipHorizontal
            self.view.window!.backgroundColor = UIColor.greenColor() // prove window shows thru
            // no transition on present, only on dismiss; bug?
        default: break
        }
        
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
    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)!) {
        println("here") // prove that this is called by clicking on curl
        super.dismissViewControllerAnimated(flag, completion: completion)
    }
    
    
}
