

import UIKit

// summoned by "i" button in first popover
// notice that preferred content size is obeyed

class ExtraViewController : UIViewController {
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .CurrentContext
        self.preferredContentSize = CGSizeMake(320,220)
    }
    
    @IBAction func doButton(sender:AnyObject) {
        println("extra view controller view frame: \(self.view.frame)")
        self.dismissViewControllerAnimated(true, completion:{
            println("dismissed")
            })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRectMake(0,0,320,220)
    }
    
    deinit {
        println("dealloc extra view controller")
    }
    
}