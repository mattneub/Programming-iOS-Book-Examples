

import UIKit

class ViewController : UIViewController, UINavigationControllerDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.title = "First"
                
        // how to customize back button
        let b3 = UIBarButtonItem(image:UIImage(named:"files.png"), style:.plain, target:nil, action:nil)
        self.navigationItem.backBarButtonItem = b3

    }
    
    // instantiation, navigation now performed through storyboard setup
    /*
    func navigate() {
        let v2c = View2Controller()
        self.navigationController.pushViewController(v2c, animated: true)
    }
*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.delegate = self
        
    // self.navigationItem.backBarButtonItem?.setBackButtonBackgroundImage(
     //   UIImage(named:"linen")!, for: .normal, barMetrics: .default)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(self.navigationController?.navigationBar.standardAppearance as Any)
        print(self.navigationController?.navigationBar.scrollEdgeAppearance as Any)
    }
    
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
}
