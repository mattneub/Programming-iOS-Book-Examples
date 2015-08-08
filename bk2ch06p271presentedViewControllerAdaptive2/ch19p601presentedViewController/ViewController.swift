

import UIKit

class ViewController : UIViewController, SecondViewControllerDelegate {
    
    var original : UIModalPresentationStyle! = .FullScreen
    var adaptive : UIModalPresentationStyle! = .FullScreen
    lazy var pairs : [(Int, Int)] = {
        // the ones we want to test are 0, 1, 2, 5
        // hmm, I would also like to know what happens about -1
        let arr1 = [0, 1, 2, 5]
        let arr2 = [0, 1, 2, 5, -1]
        var result = [(Int, Int)]()
        for i in arr1 {
            for j in arr2 {
                result.append(i,j)
            }
        }
        return result
    }()
    var ix = 0
    
    @IBAction func doAdvance(sender: AnyObject) {
        let pair = self.pairs[self.ix]
        self.original = UIModalPresentationStyle(rawValue:pair.0)
        self.adaptive = UIModalPresentationStyle(rawValue:pair.1)
        self.ix++
    }
    
    @IBAction func doPresent(sender:AnyObject?) {
        
        print(original.rawValue, appendNewline:false)
        print("\t", appendNewline:false)
        print(adaptive.rawValue, appendNewline:false)
        print("\t", appendNewline:false)

        
        
        let svc = SecondViewController(nibName: "SecondViewController", bundle: nil)
        svc.data = "This is very important data!"
        svc.delegate = self
        
        svc.modalPresentationStyle = self.original

        svc.presentationController!.delegate = self // *
        
        self.presentViewController(svc, animated:true, completion:nil)
    }
    
    func acceptData(data:AnyObject!) {
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)!) {
        super.dismissViewControllerAnimated(flag, completion: completion)
    }
    
    
}

extension ViewController : UIAdaptivePresentationControllerDelegate {
//    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
//        return .OverFullScreen
//    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        // print("adapt!")
        return self.adaptive
    }
    
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let newvc = ThirdViewController(nibName: "ThirdViewController", bundle: nil)
        newvc.data = "This is very important data!"
        newvc.delegate = self

        // print("newvc!")
        return newvc
    }
    
    func presentationController(presentationController: UIPresentationController, willPresentWithAdaptiveStyle style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        print(style.rawValue, appendNewline:false)
        print("\t", appendNewline:false)
    }
    
    /*
    
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
