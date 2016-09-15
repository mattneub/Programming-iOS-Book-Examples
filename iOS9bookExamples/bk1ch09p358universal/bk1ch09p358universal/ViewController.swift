

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let iv = UIImageView(image: UIImage(named:"Image")!)
        iv.frame.origin = CGPointMake(10,150)
        self.view.addSubview(iv)
        
        let device = self.traitCollection.userInterfaceIdiom == .Pad ? "iPad" : "iPhone"
        print(device)
        
    }



}

