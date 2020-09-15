

import UIKit

class ViewController : UIViewController, SecondViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.modalPresentationStyle.rawValue)
    }

    @IBAction func doPresent(_ sender: Any?) {
        
        // logging to prove these are normally nil
        print(self.presentingViewController as Any)
        print(self.presentedViewController as Any)
        
        let svc = SecondViewController()
        svc.data = "This is very important data!"
        svc.delegate = self
        
        var which : Int { return 1 }
        switch which {
        case 1: break // showing that .coverVertical is the default
        case 2: svc.modalTransitionStyle = .coverVertical
        case 3: svc.modalTransitionStyle = .crossDissolve // wow, this looks like crap
        case 4: svc.modalTransitionStyle = .partialCurl
            // partial curl is not partial in iOS 8/9/10/11; bug?
            // thus, the "click to dismiss" feature makes no sense
            // user taps background and presented vc just dismisses
            // see workaround in other view controller
            // well, in iOS 13 you can't really dismiss at all
            // it just freezes up
        case 5:
            svc.modalTransitionStyle = .flipHorizontal
            self.view.window!.backgroundColor = UIColor.green // prove window shows thru
            // no transition on present, only on dismiss; bug? - ok, fixed
        default: break
        }
        
        print(self.traitCollection)
        
        var which2 : Int { return -1 }
        switch which2 {
        case -1: break // showing that .fullScreen is the default
            // but not in iOS 13! if you don't specify anything,
            // you get .automatic, which resolves to .pageSheet
            // except in compact vertical
        case 0: svc.modalPresentationStyle = .fullScreen
        case 1: svc.modalPresentationStyle = .pageSheet
        case 2: svc.modalPresentationStyle = .formSheet
        case 5:
            svc.modalPresentationStyle = .overFullScreen
            // svc.view.alpha = 0.5 // just to prove that it's working
        case 6:
            if #available(iOS 13.0, *) {
                svc.modalPresentationStyle = .automatic
                // svc.isModalInPresentation = true
            }
        default: break
        }
        
        /*
         Presentation modes are:
         UIModalPresentationFullScreen = 0,
         UIModalPresentationPageSheet,
         UIModalPresentationFormSheet,
         UIModalPresentationCurrentContext,
         UIModalPresentationCustom,
         UIModalPresentationOverFullScreen,
         UIModalPresentationOverCurrentContext,
         UIModalPresentationPopover,
         UIModalPresentationNone = -1,
         UIModalPresentationAutomatic = -2,
         */
        
        self.present(svc, animated:true) {
            print(svc.view.gestureRecognizers as Any)
            print(svc.modalPresentationStyle.rawValue)
            print(svc.presentationController?.adaptivePresentationStyle.rawValue)
        }
        // self.showViewController(svc, sender:self) // ooops! we're in a nav interface, uses that :)
        
        svc.presentationController?.delegate = self // proving this works even after presentation
    }
    
    func accept(data:Any) {
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

/*
// Called on the delegate when the presentation controller will dismiss in response to user action.
// This method is not called if the presentedViewController isModalInPresentation or if the presentation is dismissed programatically.
// Return NO to prevent dismissal of the view controller.
- (BOOL)presentationControllerShouldDismiss:(UIPresentationController *)presentationController API_AVAILABLE(ios(13.0));

// Called on the delegate when the user has taken action to dismiss the presentation, before interaction or animations begin.
// Use this callback to setup alongside animations or interaction notifications with the presentingViewController's transitionCoordinator.
// This is not called if the presentation is dismissed programatically.
- (void)presentationControllerWillDismiss:(UIPresentationController *)presentationController API_AVAILABLE(ios(13.0));

// Called on the delegate when the user has taken action to dismiss the presentation successfully, after all animations are finished.
// This is not called if the presentation is dismissed programatically.
- (void)presentationControllerDidDismiss:(UIPresentationController *)presentationController API_AVAILABLE(ios(13.0));

// Called on the delegate when the user attempts to dismiss the presentation, but user-initiated dismissal is prevented because the presentedViewController isModalInPresentation or presentationControllerShouldDismiss: returned NO.
// When this method is called, it is recommended that the user be informed why they cannot dismiss the presentation, such as by presenting an instance of UIAlertController.
- (void)presentationControllerDidAttemptToDismiss:(UIPresentationController *)presentationController API_AVAILABLE(ios(13.0));
*/

extension ViewController : UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ pc: UIPresentationController) {
        print("hey, stop that")
    }
    func presentationControllerShouldDismiss(_ pc: UIPresentationController) -> Bool {
        return true
    }
    func presentationControllerWillDismiss(_ pc: UIPresentationController) {
        print("will")
        if let tc = pc.presentedViewController.transitionCoordinator {
            tc.animate(alongsideTransition: {_ in
                for v in pc.presentedViewController.view.subviews {
                    v.alpha = 0
                }
            })
        }
    }
    func presentationControllerDidDismiss(_ pc: UIPresentationController) {
        print("did")
    }

}
