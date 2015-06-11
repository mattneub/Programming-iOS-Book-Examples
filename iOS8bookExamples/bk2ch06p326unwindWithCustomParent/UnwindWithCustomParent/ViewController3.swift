
import UIKit

class ViewController3: UIViewController {

    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
        var result = true
        
        println("view controller 3 can perform returns \(result)")
        return result
    }


}
