
import UIKit

class PopoverViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSizeMake(320,230)
    }
    
    @IBAction func showOptions(sender:AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        func handler(act:UIAlertAction!) {
            println("User tapped \(act.title)")
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: handler))
        alert.addAction(UIAlertAction(title: "Hey", style: .Default, handler: handler))
        alert.addAction(UIAlertAction(title: "Ho", style: .Default, handler: handler))
        alert.addAction(UIAlertAction(title: "Hey Nonny No", style: .Default, handler: handler))
        // .OverCurrentContext is the default, so no need to specify! just show it
        self.presentViewController(alert, animated: true, completion: nil)
        // tapping outside the sheet but inside the containing popover dismisses the sheet
        // tapping outside the containing popover dismisses the popover
        // to prevent that, you have to take charge of dismissal
        // No, the above is fixed in iOS 8.3
    }

}
