

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
        let v2c = View2Controller()
        self.navigationController!.pushViewController(v2c, animated: true)
        // alternatively, can use new way in iOS 8:
        // self.showViewController(v2c, sender: self)
        // makes no difference here; the purpose is to loosen the coupling ...
        // ... in a possible split view controller situation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.delegate = self
        
        // large titles
        self.navigationController!.navigationBar.prefersLargeTitles = true
        
        // new in iOS 13, when we have a large title, the navigation bar is completely transparent by default
        // if you don't like that, set background color for the scroll edge appearance
        let app = UINavigationBarAppearance()
        app.backgroundColor = UIColor.systemRed // will be white otherwise, I think
        // note that this causes the nav bar color in the storyboard to stop working
        // if we want translucency, we now refer to blur effect directly (and/or use materials)
        app.backgroundColor = app.backgroundColor?.withAlphaComponent(0.7)
        app.backgroundEffect = UIBlurEffect(style: .light)
        
        
        self.navigationController!.navigationBar.standardAppearance = app
        self.navigationController!.navigationBar.scrollEdgeAppearance = app
        
        // uncomment to get white status bar text
        // but this stops working if you use the new iOS 13 appearance stuff
        self.navigationController!.navigationBar.barStyle = .black
        // however, in iOS 13 you also get automatic status bar style based on user interface mode (light/dark)
        
        // uncomment to hide navigation bar
        // self.navigationController!.setNavigationBarHidden(true, animated: false)

    }
    
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
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
