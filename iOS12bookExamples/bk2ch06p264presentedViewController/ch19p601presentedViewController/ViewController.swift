

import UIKit

class ViewController : UIViewController, SecondViewControllerDelegate {
    

    @IBAction func doPresent(_ sender: Any?) {
        
        // logging to prove these are normally nil
        print(self.presentingViewController as Any)
        print(self.presentedViewController as Any)
        
        let svc = SecondViewController(nibName: nil, bundle: nil)
        svc.data = "This is very important data!"
        svc.delegate = self
        
        var which : Int { return 2 }
        switch which {
        case 1: break // showing that .CoverVertical is the default
        case 2: svc.modalTransitionStyle = .coverVertical
        case 3: svc.modalTransitionStyle = .crossDissolve // wow, this looks like crap
        case 4: svc.modalTransitionStyle = .partialCurl
            // partial curl is not partial in iOS 8/9/10/11; bug?
            // thus, the "click to dismiss" feature makes no sense
            // user taps background and presented vc just dismisses
            // see workaround in other view controller
        case 5:
            svc.modalTransitionStyle = .flipHorizontal
            self.view.window!.backgroundColor = UIColor.green // prove window shows thru
            // no transition on present, only on dismiss; bug? - ok, fixed
        default: break
        }
        
        print(self.traitCollection)
        
        var which2 : Int { return 3 }
        switch which2 {
        case 1: break // showing that .FullScreen is the default
        case 2: svc.modalPresentationStyle = .fullScreen
        case 3: svc.modalPresentationStyle = .pageSheet
        case 4: svc.modalPresentationStyle = .formSheet
        case 5:
            svc.modalPresentationStyle = .overFullScreen
            svc.view.alpha = 0.5 // just to prove that it's working
        default: break
        }
        
        self.present(svc, animated:true) {
            print(svc.view.gestureRecognizers as Any)
        }
        // self.showViewController(svc, sender:self) // ooops! we're in a nav interface, uses that :)
    }
    
    func accept(data:Any!) {
        // do something with data here
        
        // prove that you received data
        print(data)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("vc did disappear")
    }
    
    override func dismiss(animated: Bool, completion: (() -> Void)?) {
        print("dismiss!") // prove that this is called by clicking on curl
        super.dismiss(animated:animated, completion:completion)
    }
    
    
}
