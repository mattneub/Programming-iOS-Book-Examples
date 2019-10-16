

import UIKit

class ViewController : UIViewController, UINavigationControllerDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.title = "First"
        let b = UIBarButtonItem(image:UIImage(named:"key"), style:.plain, target:self, action:#selector(navigate))
        let b2 = UIBarButtonItem(image:UIImage(named:"files"),
        style:.plain, target:nil, action:nil)
        self.navigationItem.rightBarButtonItems = [b, b2]
        
        // how to customize back button
        let b3 = UIBarButtonItem(image:UIImage(named:"files"), style:.plain, target:nil, action:nil)
        self.navigationItem.backBarButtonItem = b3
        
    }
    
    @objc func navigate() {
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
        // uncomment to get white status bar text
        // self.navigationController!.navigationBar.barStyle = .Black
        // uncomment to hide navigation bar
        // self.navigationController!.setNavigationBarHidden(true, animated: false)
        
        // large titles
        self.navigationController!.navigationBar.prefersLargeTitles = true
    }
    
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
//    override var preferredStatusBarStyle : UIStatusBarStyle {
//        return .lightContent
//    }
    
//    override var prefersStatusBarHidden : Bool {
//        return true
//    }

//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        print("is moving from", self.isMovingFromParent)
//    }
//    
//    override func didMove(toParent parent: UIViewController?) {
//        print("did move to", parent == nil)
//    }


}
