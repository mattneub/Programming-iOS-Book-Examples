

import UIKit

// summoned by "i" button in first popover
// notice that preferred content size is obeyed

class ExtraViewController : UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "ExtraViewController", bundle: nibBundleOrNil)
        self.modalPresentationStyle = .CurrentContext
        self.preferredContentSize = CGSizeMake(320,220)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    @IBAction func doButton(sender:AnyObject) {
        print("extra view controller view frame: \(self.view.frame)")
        self.dismissViewControllerAnimated(true, completion:{
            print("dismissed")
            })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRectMake(0,0,320,220)
    }
    
    deinit {
        print("dealloc extra view controller")
    }
    
}