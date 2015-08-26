

import UIKit

class FirstViewController : UIViewController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
    }
    
    // tab bar delegate gets to dictate orientations...
    // so there's no need to subclass UITabBarController
    
    func tabBarControllerSupportedInterfaceOrientations(tabBarController: UITabBarController) -> UIInterfaceOrientationMask {
        print(self, terminator: "")
        print(" ", terminator: "")
        print(__FUNCTION__)
        return .Portrait    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        print(self, terminator: "")
        print(" ", terminator: "")
        print(__FUNCTION__)
        return .Landscape // called, but pointless
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    
}