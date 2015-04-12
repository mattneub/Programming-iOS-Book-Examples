

import UIKit

class ViewController : UIViewController, UINavigationControllerDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.title = "First"
        let b = UIBarButtonItem(image:UIImage(named:"key.png"), style:.Plain, target:self, action:"navigate")
        let b2 = UIBarButtonItem(image:UIImage(named:"files.png"),
        style:.Plain, target:nil, action:nil)
        self.navigationItem.rightBarButtonItems = [b, b2]
        
        // how to customize back button
        let b3 = UIBarButtonItem(image:UIImage(named:"files.png"), style:.Plain, target:nil, action:nil)
        self.navigationItem.backBarButtonItem = b3

    }
    
    func navigate() {
        let v2c = View2Controller(nibName: nil, bundle: nil)
        self.navigationController!.pushViewController(v2c, animated: true)
        // alternatively, can use new way in iOS 8:
        // self.showViewController(v2c, sender: self)
        // makes no difference here; the purpose is to loosen the coupling ...
        // ... in a possible split view controller situation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.delegate = self
    }
    
    func navigationControllerSupportedInterfaceOrientations(navigationController: UINavigationController) -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    // wow, this causes a nasty bug
    
    /*
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

*/
    
}
