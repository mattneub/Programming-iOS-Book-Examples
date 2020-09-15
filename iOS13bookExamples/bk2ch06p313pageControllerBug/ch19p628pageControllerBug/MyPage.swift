

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
    
    init() {
        super.init(nibName: "MyPage", bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lab.text = "\(self.num)"
    }
}
