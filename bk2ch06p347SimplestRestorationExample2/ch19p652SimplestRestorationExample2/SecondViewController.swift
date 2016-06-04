

import UIKit

class SecondViewController : UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self.dynamicType) will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self.dynamicType) did appear")
    }

    override func encodeRestorableState(with coder: NSCoder) {
        print("\(self.dynamicType) encode \(coder)")
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        print("\(self.dynamicType) decode \(coder)")
    }
    
    override func applicationFinishedRestoringState() {
        print("finished \(self.dynamicType)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load \(self.dynamicType)")
        self.view.backgroundColor = UIColor.yellow()
        let button = UIButton(type:.system)
        button.setTitle("Present", for:[])
        button.addTarget(self,
            action:#selector(doPresent),
            for:.touchUpInside)
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
    
    func doPresent(_ sender:AnyObject?) {
        let pvc = self.dynamicType.makePresentedViewController()
        self.present(pvc, animated:true)
    }
}

// a classic mistake is to implement viewControllerWithRestorationIdentifierPath...
// but forget to declare explicit conformance to UIViewControllerRestoration
// in that case, restoration will fail, without a crash,
// but now (new in iOS 8?) with a delightfully helpful message:
// "Warning: restoration class for view controller does not conform to UIViewControllerRestoration protocol: Class is ..."

extension SecondViewController : UIViewControllerRestoration {
    class func viewController(withRestorationIdentifierPath ip: [AnyObject],
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

