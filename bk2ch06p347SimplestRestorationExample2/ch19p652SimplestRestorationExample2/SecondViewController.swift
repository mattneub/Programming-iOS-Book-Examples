

import UIKit

class SecondViewController : UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self.dynamicType) will appear")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self.dynamicType) did appear")
    }

    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        print("\(self.dynamicType) encode \(coder)")
    }
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        print("\(self.dynamicType) decode \(coder)")
    }
    
    override func applicationFinishedRestoringState() {
        print("finished \(self.dynamicType)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load \(self.dynamicType)")
        self.view.backgroundColor = UIColor.yellowColor()
        let button = UIButton(type:.System)
        button.setTitle("Present", forState:.Normal)
        button.addTarget(self,
            action:"doPresent:",
            forControlEvents:.TouchUpInside)
        button.sizeToFit()
        button.center = self.view.center
        self.view.addSubview(button)
    }
    
    class func makePresentedViewController () -> UIViewController {
        let pvc = PresentedViewController()
        pvc.restorationIdentifier = "presented"
        pvc.restorationClass = self
        return pvc
    }
    
    func doPresent(sender:AnyObject?) {
        let pvc = self.dynamicType.makePresentedViewController()
        self.presentViewController(pvc, animated:true, completion:nil)
    }
}

// a classic mistake is to implement viewControllerWithRestorationIdentifierPath...
// but forget to declare explicit conformance to UIViewControllerRestoration
// in that case, restoration will fail, without a crash,
// but now (new in iOS 8?) with a delightfully helpful message:
// "Warning: restoration class for view controller does not conform to UIViewControllerRestoration protocol: Class is ..."

extension SecondViewController : UIViewControllerRestoration {
    class func viewControllerWithRestorationIdentifierPath(ip: [AnyObject],
        coder: NSCoder) -> UIViewController? {
            print("vcwithrip \(NSStringFromClass(self)) \(ip) \(coder)")
            var vc : UIViewController? = nil
            let last = ip.last as! String
            switch last {
            case "presented":
                vc = self.makePresentedViewController()
            default: break
            }
            return vc
    }
}

