

import UIKit

class LoginViewController: UIViewController {
    var message : String = ""
    convenience init(coder:NSCoder, message:String) {
        self.init(coder:coder)!
        self.message = message
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(self.message)
    }


}

