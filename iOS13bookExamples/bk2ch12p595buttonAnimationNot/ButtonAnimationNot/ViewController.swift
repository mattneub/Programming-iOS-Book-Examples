

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button2: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func dobutton1(_ sender: Any) {
        let t = NSAttributedString(string: "howdy", attributes: [.foregroundColor: UIColor.red])
        self.button2.setAttributedTitle(t, for: .normal)
        UIView.performWithoutAnimation {
            self.button2.layoutIfNeeded()
        }
    }
    
}

