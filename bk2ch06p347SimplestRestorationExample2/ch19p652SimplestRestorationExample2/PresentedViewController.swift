
import UIKit

class PresentedViewController : UIViewController {
    
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        println("\(self) encode \(coder)")
    }
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        println("\(self) decode \(coder)")
    }
    
    override func applicationFinishedRestoringState() {
        println("finished \(self)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        println("view did load \(self)")
        self.view.backgroundColor = UIColor.blueColor()
        let button = UIButton.buttonWithType(.System) as! UIButton
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
