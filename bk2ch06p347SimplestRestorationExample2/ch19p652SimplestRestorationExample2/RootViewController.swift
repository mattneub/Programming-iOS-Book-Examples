
import UIKit

class RootViewController : UIViewController {
    
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
        self.view.backgroundColor = .green
        let b = UIBarButtonItem(title:"Push",
            style:.plain, target:self, action:#selector(doPush))
        self.navigationItem.rightBarButtonItem = b
        let button = UIButton(type:.system)
        button.setTitle("Present", for:.normal)
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
    
    class func makeSecondViewController () -> UIViewController {
        let svc = SecondViewController()
        svc.restorationIdentifier = "second"
        svc.restorationClass = self
        return svc
    }
    
    func doPresent(_ sender:AnyObject?) {
        let pvc = self.dynamicType.makePresentedViewController()
        self.present(pvc, animated:true)
    }
    
    func doPush(_ sender:AnyObject?) {
        let svc = self.dynamicType.makeSecondViewController()
        self.navigationController!.pushViewController(svc, animated:true)
    }
}

// a classic mistake is to implement viewControllerWithRestorationIdentifierPath...
// but forget to declare explicit conformance to UIViewControllerRestoration
// in that case, restoration will fail, without a crash,
// but now (new in iOS 8?) with a delightfully helpful message:
// "Warning: restoration class for view controller does not conform to UIViewControllerRestoration protocol: Class is ..."

extension RootViewController : UIViewControllerRestoration {
    class func viewController(withRestorationIdentifierPath ip: [AnyObject],
        coder: NSCoder) -> UIViewController? {
            print("vcwithrip \(NSStringFromClass(self)) \(ip) \(coder)")
            var vc : UIViewController? = nil
            let last = ip.last as! String
            switch last {
            case "presented":
                vc = self.makePresentedViewController()
            case "second":
                vc = self.makeSecondViewController()
            default: break
            }
            return vc
    }
}
