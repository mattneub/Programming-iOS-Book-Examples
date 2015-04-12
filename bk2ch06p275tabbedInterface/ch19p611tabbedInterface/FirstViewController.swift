

import UIKit

class FirstViewController : UIViewController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
    }
    
    // tab bar delegate gets to dictate orientations...
    // so there's no need to subclass UITabBarController
    
    func tabBarControllerSupportedInterfaceOrientations(tabBarController: UITabBarController) -> Int {
        print(self)
        print(" ")
        println(__FUNCTION__)
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    override func supportedInterfaceOrientations() -> Int {
        print(self)
        print(" ")
        println(__FUNCTION__)
        return Int(UIInterfaceOrientationMask.Landscape.rawValue) // called, but pointless
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    
}