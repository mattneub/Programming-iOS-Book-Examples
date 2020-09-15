
import UIKit

class MySplitViewController : UISplitViewController {
    override func targetViewController(forAction action: Selector, sender: Any?) -> UIViewController? {
        print(self, #function, action, "called")
        let result = super.targetViewController(forAction: action, sender: sender)
        print(self, #function, result as Any)
        return result
    }
    override func showHide(_ sender: Any) {
        print(self, #function, "called")
    }
}

class MyNavigationController : UINavigationController {
    override func targetViewController(forAction action: Selector, sender: Any?) -> UIViewController? {
        print(self, #function, action, "called")
        let result = super.targetViewController(forAction: action, sender: sender)
        print(self, #function, result as Any)
        return result
    }
}

extension UIViewController {
    @objc func showHide(_ sender: Any) {
        if let target = self.targetViewController(
            forAction:#selector(showHide), sender: sender) {
            target.showHide(self)
        }
    }
}
