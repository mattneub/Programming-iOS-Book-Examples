
import UIKit

class ViewController3: UIViewController {

    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        let result = super.canPerformUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
        
        print("view controller 3 can perform returns \(result)")
        return result
    }
    
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print("view controller 3 told to unwind for segue")
        super.unwindForSegue(unwindSegue, towardsViewController:subsequentVC)
    }



}
