
import UIKit

class RootViewController : UIViewController {
    
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        println("\(self) encode \(coder)")
    }
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        println("\(self) decode \(coder)")
    }
    
    override func applicationFinishedRestoringState() {
        println("finished \(self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("view did load \(self)")
        self.view.backgroundColor = UIColor.greenColor()
        let b = UIBarButtonItem(title:"Push",
            style:.Plain, target:self, action:"doPush:")
        self.navigationItem.rightBarButtonItem = b
        let button = UIButton.buttonWithType(.System) as! UIButton
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
    
    class func makeSecondViewController () -> UIViewController {
        let svc = SecondViewController()
        svc.restorationIdentifier = "second"
        svc.restorationClass = self
        return svc
    }
    
    func doPresent(sender:AnyObject?) {
        let pvc = self.dynamicType.makePresentedViewController()
        self.presentViewController(pvc, animated:true, completion:nil)
    }
    
    func doPush(sender:AnyObject?) {
        let pvc = self.dynamicType.makeSecondViewController()
        self.navigationController!.pushViewController(pvc, animated:true)
    }
}

// a classic mistake is to implement viewControllerWithRestorationIdentifierPath...
// but forget to declare explicit conformance to UIViewControllerRestoration
// in that case, restoration will fail, without a crash,
// but now (new in iOS 8?) with a delightfully helpful message:
// "Warning: restoration class for view controller does not conform to UIViewControllerRestoration protocol: Class is ..."

extension RootViewController : UIViewControllerRestoration {
    class func viewControllerWithRestorationIdentifierPath(ip: [AnyObject],
        coder: NSCoder) -> UIViewController? {
            println("vcwithrip \(NSStringFromClass(self)) \(ip) \(coder)")
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
