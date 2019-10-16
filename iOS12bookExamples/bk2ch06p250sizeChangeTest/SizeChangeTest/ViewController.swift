
func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

import UIKit

// demonstrating that a size change without rotation is not notified to the view controller
// I find this rather odd, but I suppose it's because this is not a transition coordinator situation
// (i.e. rotation)

class ViewController: UIViewController {
    
    @IBAction func doButton(_ sender: Any) {
        print(self.view.bounds.size)
        let nav = self.navigationController!
        nav.isNavigationBarHidden = !nav.isNavigationBarHidden
        delay(1) {
            print("size did in fact change")
            print(self.view.bounds.size)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            forName: UIApplication.willChangeStatusBarOrientationNotification,
            object: nil, queue: nil) { n in
                print("status bar will change orientation from",
                      UIApplication.shared.statusBarOrientation.rawValue,
                      "to",
                      n.userInfo?[UIApplication.statusBarOrientationUserInfoKey] as Any)
        }
        NotificationCenter.default.addObserver(
            forName: UIApplication.didChangeStatusBarOrientationNotification,
            object: nil, queue: nil) { n in
                print("status bar did change orientation from",
                      n.userInfo?[UIApplication.statusBarOrientationUserInfoKey] as Any,
                      "to",
                      UIApplication.shared.statusBarOrientation.rawValue)
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with: coordinator)
        print("size will transition")
        print(size)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        print("trait collection changed")
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to:newCollection, with: coordinator)
        print("trait collection will transition")
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        print("update view constraints")
    }
    
    override func viewWillLayoutSubviews() {
        print("will layout")
    }
    
    override func viewDidLayoutSubviews() {
        print("did layout")
    }
    
    
}

