

import UIKit

class ViewController : UIViewController, UINavigationControllerDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.title = "First"
        // right bar button item now set up in storyboard so we can use a "show" segue
        let b2 = UIBarButtonItem(image:UIImage(named:"files.png"), style:.Plain, target:nil, action:nil)
        // how to append additional right bar button items
        var rbbi = self.navigationItem.rightBarButtonItems as! [UIBarButtonItem]
        rbbi += [b2]
        self.navigationItem.rightBarButtonItems = rbbi
        
        // how to customize back button
        let b3 = UIBarButtonItem(image:UIImage(named:"files.png"), style:.Plain, target:nil, action:nil)
        self.navigationItem.backBarButtonItem = b3

    }
    
    // instantiation, navigation now performed through storyboard setup
    /*
    func navigate() {
        let v2c = View2Controller(nibName: nil, bundle: nil)
        self.navigationController.pushViewController(v2c, animated: true)
    }
*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.delegate = self
    }
    
    func navigationControllerSupportedInterfaceOrientations(navigationController: UINavigationController) -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
}
