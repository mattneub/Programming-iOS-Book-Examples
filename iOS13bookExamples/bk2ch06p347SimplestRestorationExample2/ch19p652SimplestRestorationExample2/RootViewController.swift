
import UIKit

struct S : Codable {
    let name : String
}

class RootViewController : UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(type(of:self)) will appear")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(type(of:self)) did appear")
    }
    
    
    override func encodeRestorableState(with coder: NSCoder) {
        print("\(type(of:self)) encode \(coder)")
        // watch _this_ little move
        try! (coder as! NSKeyedArchiver).encodeEncodable(S(name:"matt"), forKey: "testing")
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        print("\(type(of:self)) decode \(coder)")
        // ready? abracadabra!
        if let m = (coder as! NSKeyedUnarchiver).decodeDecodable(S.self, forKey: "testing") {
            print(m.name)
        }
    }
    
    override func applicationFinishedRestoringState() {
        print("finished \(type(of:self))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load \(type(of:self))")
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
    
    @objc func doPresent(_ sender: Any?) {
        let pvc = type(of:self).makePresentedViewController()
        self.present(pvc, animated:true)
    }
    
    @objc func doPush(_ sender: Any?) {
        let svc = type(of:self).makeSecondViewController()
        self.navigationController!.pushViewController(svc, animated:true)
    }
}

// a classic mistake is to implement viewControllerWithRestorationIdentifierPath...
// but forget to declare explicit conformance to UIViewControllerRestoration
// in that case, restoration will fail, without a crash,
// but now (new in iOS 8?) with a delightfully helpful message:
// "Warning: restoration class for view controller does not conform to UIViewControllerRestoration protocol: Class is ..."

extension RootViewController : UIViewControllerRestoration {
    class func viewController(withRestorationIdentifierPath ip: [String],
        coder: NSCoder) -> UIViewController? {
            print("vcwithrip \(NSStringFromClass(self)) \(ip) \(coder)")
            var vc : UIViewController? = nil
            let last = ip.last!
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
