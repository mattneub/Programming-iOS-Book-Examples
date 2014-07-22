

import UIKit

class MyPage : UIViewController {
    @IBOutlet var lab : UILabel!
    var num : Int = 0 {
    didSet {
        if let lab = self.lab {
            lab.text = "\(self.num)"
        }
    }
    }
    
    init () {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lab.text = "\(self.num)"
    }
}
