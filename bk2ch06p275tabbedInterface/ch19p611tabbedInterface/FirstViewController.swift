

import UIKit


class FirstViewController : UIViewController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
    }
    
    // tab bar delegate gets to dictate orientations...
    // so there's no need to subclass UITabBarController
    
    func tabBarControllerSupportedInterfaceOrientations(_ tabBarController: UITabBarController) -> UIInterfaceOrientationMask {
        print(self, terminator: "")
        print(" ", terminator: "")
        print(#function)
        return .portrait    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        print(self, terminator: "")
        print(" ", terminator: "")
        print(#function)
        return .landscape // called, but pointless
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    

    
}
