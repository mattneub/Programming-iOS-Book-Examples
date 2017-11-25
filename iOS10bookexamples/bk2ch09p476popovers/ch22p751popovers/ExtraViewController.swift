

import UIKit

// summoned by "i" button in first popover
// notice that preferred content size is obeyed

class ExtraViewController : UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "ExtraViewController", bundle: nibBundleOrNil)
        self.modalPresentationStyle = .currentContext
        self.preferredContentSize = CGSize(320,220)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    @IBAction func doButton(_ sender: Any) {
        print("extra view controller view frame: \(self.view.frame)")
        self.dismiss(animated:true) {
            print("dismissed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(0,0,320,220)
    }
    
    deinit {
        print("dealloc extra view controller")
    }
    
}
