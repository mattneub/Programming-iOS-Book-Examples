

import UIKit

class ViewController : UIViewController, SecondViewControllerDelegate {
    
    @IBAction func doPresent(sender:AnyObject?) {
        
        
        let svc = SecondViewController(nibName: "SecondViewController", bundle: nil)
        svc.data = "This is very important data!"
        svc.delegate = self
        
        svc.modalPresentationStyle = .PageSheet

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
        return .FormSheet
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
    
    /*
    
    ==== on iPad ====
    
    original FormSheet, adapt FormSheet or PageSheet
    view controller not called, presenting with None, appears as FormSheet
    
    original FormSheet, adapt FullScreen or OverFullScreen
    view controller called, presents as specified
    
    original PageSheet, adapt PageSheet
    view controller not called, presenting with None, appears as PageSheet
    
    original PageSheet, adapt FormSheet
    view controller called, presents as specified (FormSheet)
    
    original FullScreen, adapt FullScreen or OverFullScreen or PageSheet or FormSheet
    view controller not called, presents as FullScreen
    
    original OverFullScreen, adapt FullScreen or OverFullScreen or PageSheet or FormSheet
    view controller not called, presents as OverFullScreen
    
    ==== on iPhone ====
    
    original FormSheet, adapt FormSheet
    view controller not called, presenting with None, appears as FormSheet (!) - looks like page sheet on phone
    
    original FormSheet, adapt PageSheet
    view controller called, presenting FullScreen

    original FormSheet, adapt FullScreen or OverFullScreen
    view controller called, presenting as specified (FullScreen or OverFullScreen)
    
    original PageSheet, adapt PageSheet
    view controller called, presenting FullScreen

    original PageSheet, adapt FormSheet
    view controller called, presenting FormSheet (!) looks like page sheet on phone

    original FullScreen, adapt FullScreen or OverFullScreen or PageSheet or FormSheet

    
    original OverFullScreen, adapt FullScreen or OverFullScreen or PageSheet or FormSheet

    
    
    
    ====
    
    UIModalPresentationFullScreen = 0,
    UIModalPresentationPageSheet NS_ENUM_AVAILABLE_IOS(3_2),
    UIModalPresentationFormSheet NS_ENUM_AVAILABLE_IOS(3_2),
    UIModalPresentationCurrentContext NS_ENUM_AVAILABLE_IOS(3_2),
    UIModalPresentationCustom NS_ENUM_AVAILABLE_IOS(7_0),
    UIModalPresentationOverFullScreen NS_ENUM_AVAILABLE_IOS(8_0),
    UIModalPresentationOverCurrentContext NS_ENUM_AVAILABLE_IOS(8_0),
    UIModalPresentationPopover NS_ENUM_AVAILABLE_IOS(8_0),
    UIModalPresentationNone NS_ENUM_AVAILABLE_IOS(7_0) = -1,

    
*/


}
