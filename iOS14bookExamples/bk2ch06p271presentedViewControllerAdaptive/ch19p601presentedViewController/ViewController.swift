

import UIKit

class ViewController : UIViewController, SecondViewControllerDelegate {
    
    @IBAction func doPresent(_ sender: Any?) {
        
        
        let svc = SecondViewController()
        svc.data = "This is very important data!"
        svc.delegate = self
        
        // gosh, in iOS what if I don't say that?
        // .pageSheet is the default, so do we still adapt?
        // yes we do!
        // svc.modalPresentationStyle = .pageSheet

        svc.presentationController!.delegate = self // *
        // must be _before_ `present`
        
        self.present(svc, animated:true)
        

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
        print("here") // prove that this is called by clicking on curl
        super.dismiss(animated:animated, completion: completion)
    }
    
    
}

extension ViewController : UIAdaptivePresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        print("adapt!")
        if traitCollection.horizontalSizeClass == .compact || traitCollection.verticalSizeClass == .compact {
            return .overFullScreen
            // removed the case where you return .none here...
            // ...as it's no longer interesting in iOS 13
        }
        // return .formSheet // useful on iPad perhaps
        return .none // don't adapt
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle: UIModalPresentationStyle) -> UIViewController? {
        let newvc = ThirdViewController()
        newvc.data = "This is very important data!"
        newvc.delegate = self

        print("newvc!")
        return newvc
    }
    
    func presentationController(_ presentationController: UIPresentationController, willPresentWithAdaptiveStyle style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        print("will present with style: \(style.rawValue)")
        transitionCoordinator?.animate(alongsideTransition: nil) { tc in
            let actualStyle = tc.presentationStyle
            print("did present with style: \(actualStyle.rawValue)")
        }
    }
    
    // hmm, weird, looks like pageSheet on landscape big phone still _is_ pageSheet
    // just _looks_ like overFullScreen
    


}
