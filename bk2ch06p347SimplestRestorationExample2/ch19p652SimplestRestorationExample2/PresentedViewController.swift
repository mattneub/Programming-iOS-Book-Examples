
import UIKit

class PresentedViewController : UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self.dynamicType) will appear")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self.dynamicType) did appear")
    }

    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        print("\(self.dynamicType) encode \(coder)")
    }
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        print("\(self.dynamicType) decode \(coder)")
    }
    
    override func applicationFinishedRestoringState() {
        print("finished \(self.dynamicType)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load \(self.dynamicType)")
        self.view.backgroundColor = UIColor.blueColor()
        let button = UIButton(type:.System)
        button.setTitle("Dismiss", forState:.Normal)
        button.addTarget(self,
            action:"doDismiss:",
            forControlEvents:.TouchUpInside)
        button.sizeToFit()
        button.center = self.view.center
        button.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(button)
    }
    
    func doDismiss(sender:AnyObject?) {
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
