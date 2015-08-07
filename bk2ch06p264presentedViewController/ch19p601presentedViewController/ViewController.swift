

import UIKit

class ViewController : UIViewController, SecondViewControllerDelegate {
    
    let which = 1
    let which2 = 1

    @IBAction func doPresent(sender:AnyObject?) {
        
        // logging to prove these are normally nil
        print(self.presentingViewController)
        print(self.presentedViewController)
        
        let svc = SecondViewController(nibName: "SecondViewController", bundle: nil)
        svc.data = "This is very important data!"
        svc.delegate = self
        
        switch which {
        case 1: break // showing that .CoverVertical is the default
        case 2: svc.modalTransitionStyle = .CoverVertical
        case 3: svc.modalTransitionStyle = .CrossDissolve // wow, this looks like crap
        case 4: svc.modalTransitionStyle = .PartialCurl
            // partial curl is not partial in iOS 8/9; bug?
            // thus, the "click to dismiss" feature makes no sense
            // user taps background and presented vc just dismisses? weird; bug?
        case 5:
            svc.modalTransitionStyle = .FlipHorizontal
            self.view.window!.backgroundColor = UIColor.greenColor() // prove window shows thru
            // no transition on present, only on dismiss; bug? - ok, fixed
        default: break
        }
        
        print(self.traitCollection)

        switch which2 {
        case 1: break // showing that .FullScreen is the default
        case 2: svc.modalPresentationStyle = .FullScreen
        case 3: svc.modalPresentationStyle = .PageSheet
        case 4: svc.modalPresentationStyle = .FormSheet
        case 5:
            svc.modalPresentationStyle = .OverFullScreen
            svc.view.alpha = 0.5 // just to prove that it's working
        default: break
        }
        
        self.presentViewController(svc, animated:true, completion:nil)
        // self.showViewController(svc, sender:self) // ooops! we're in a nav interface, uses that :)
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
