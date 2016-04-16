

import UIKit

class ViewController : UIViewController, SecondViewControllerDelegate {
    
    @IBAction func doPresent(_ sender:AnyObject?) {
        
        
        let svc = SecondViewController(nibName: "SecondViewController", bundle: nil)
        svc.data = "This is very important data!"
        svc.delegate = self
        
        svc.modalPresentationStyle = .formSheet

        svc.presentationController!.delegate = self // *
        
        self.present(svc, animated:true, completion:nil)
    }
    
    func accept(data:AnyObject!) {
        // do something with data here
        
        // prove that you received data
        print(data)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("vc did disappear")
    }
    
    override func dismiss(animated: Bool, completion: (() -> Void)!) {
        print("here") // prove that this is called by clicking on curl
        super.dismiss(animated:animated, completion: completion)
    }
    
    
}

extension ViewController : UIAdaptivePresentationControllerDelegate {
//    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
//        print("adapt old!")
//        return .overFullScreen
//    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        print("adapt!")
        if traitCollection.horizontalSizeClass == .compact {
            return .overFullScreen
        }
        return .none // don't adapt, thank you
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let newvc = ThirdViewController(nibName: "ThirdViewController", bundle: nil)
        newvc.data = "This is very important data!"
        newvc.delegate = self

        print("newvc!")
        return newvc
    }
    
    func presentationController(_ presentationController: UIPresentationController, willPresentWithAdaptiveStyle style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        print("will present with style: \(style.rawValue)")
    }
    


}
