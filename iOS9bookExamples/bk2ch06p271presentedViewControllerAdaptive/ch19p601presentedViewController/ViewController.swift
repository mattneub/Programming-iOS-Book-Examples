

import UIKit

class ViewController : UIViewController, SecondViewControllerDelegate {
    
    @IBAction func doPresent(sender:AnyObject?) {
        
        
        let svc = SecondViewController(nibName: "SecondViewController", bundle: nil)
        svc.data = "This is very important data!"
        svc.delegate = self
        
        svc.modalPresentationStyle = .FormSheet

        svc.presentationController!.delegate = self // *
        
        self.presentViewController(svc, animated:true, completion:nil)
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

extension ViewController : UIAdaptivePresentationControllerDelegate {
//    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
//        print("adapt old!")
//        return .OverFullScreen
//    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        print("adapt!")
        if traitCollection.horizontalSizeClass == .Compact {
            return .OverFullScreen
        }
        return .None // don't adapt, thank you
    }
    
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let newvc = ThirdViewController(nibName: "ThirdViewController", bundle: nil)
        newvc.data = "This is very important data!"
        newvc.delegate = self

        print("newvc!")
        return newvc
    }
    
    func presentationController(presentationController: UIPresentationController, willPresentWithAdaptiveStyle style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        print("will present with style: \(style.rawValue)")
    }
    


}
