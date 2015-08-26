

import UIKit

class ViewController : UIViewController, SecondViewControllerDelegate {
    
    var original : UIModalPresentationStyle = .PageSheet
    var adaptive : UIModalPresentationStyle = .FormSheet
    lazy var pairs : [(Int, Int)] = {
        // hmm, I would also like to know what happens about -1
        let arr1 = [0, 1, 2, 3, 5, 6, 7] // I'll test popovers some other time
        let arr2 = [0, 1, 2, 3, 5, 6, 7, -1]
        var result = [(Int, Int)]()
        for i in arr1 {
            for j in arr2 {
                result.append(i,j)
            }
        }
        return result
    }()
    var ix = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .None
        self.navigationController!.definesPresentationContext = true
    }
    
    @IBAction func doAdvance(sender: AnyObject) {
        let pair = self.pairs[self.ix]
        self.original = UIModalPresentationStyle(rawValue:pair.0)!
        self.adaptive = UIModalPresentationStyle(rawValue:pair.1)!
        self.ix++
    }
    
    @IBAction func doPresent(sender:AnyObject?) {
        
        print(original.rawValue, terminator: "")
        print("\t", terminator: "")
        print(adaptive.rawValue, terminator: "")
        print("\t", terminator: "")

        let svc = SecondViewController(nibName: "SecondViewController", bundle: nil)
        svc.data = "This is very important data!"
        svc.delegate = self
        
        svc.modalPresentationStyle = self.original

        svc.presentationController!.delegate = self // *
        
        self.presentViewController(svc, animated:true, completion:nil)
        
        // just for the one case 7/-1 we will get a real popover: we have rules about that sort of thing!
        
        if let pop = svc.popoverPresentationController {
            let v = sender as! UIView
            pop.sourceView = v
            pop.sourceRect = v.bounds
        }

        
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
        print(style.rawValue, terminator: "")
        print("\t", terminator: "")
    }
    
    /*
    
    UIModalPresentationFullScreen = 0,
    UIModalPresentationPageSheet NS_ENUM_AVAILABLE_IOS(3_2), // 1
    UIModalPresentationFormSheet NS_ENUM_AVAILABLE_IOS(3_2), // 2
    UIModalPresentationCurrentContext NS_ENUM_AVAILABLE_IOS(3_2), // 3
    UIModalPresentationCustom NS_ENUM_AVAILABLE_IOS(7_0), // 4
    UIModalPresentationOverFullScreen NS_ENUM_AVAILABLE_IOS(8_0), // 5
    UIModalPresentationOverCurrentContext NS_ENUM_AVAILABLE_IOS(8_0), // 6
    UIModalPresentationPopover NS_ENUM_AVAILABLE_IOS(8_0), // 7
    UIModalPresentationNone NS_ENUM_AVAILABLE_IOS(7_0) = -1,
    
*/


}
