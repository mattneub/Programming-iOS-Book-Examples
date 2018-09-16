

import UIKit

/*
 
 Full configuration is push push present present
 
 Grand unwind all happens in perfectly good order
 Interesting how only one dismiss is needed (correctly so)
 
 View Controller 5 allowedChildViewControllersForUnwinding(from:) []
 View Controller 5 canPerformUnwindSegueAction(_:from:withSender:) doUnwind: false
 View Controller 4 allowedChildViewControllersForUnwinding(from:) []
 View Controller 4 canPerformUnwindSegueAction(_:from:withSender:) doUnwind: false
 View Controller 3 allowedChildViewControllersForUnwinding(from:) []
 View Controller 3 canPerformUnwindSegueAction(_:from:withSender:) doUnwind: false
 MyNavController allowedChildViewControllersForUnwinding(from:) [View Controller 2, View Controller 1]
 View Controller 2 allowedChildViewControllersForUnwinding(from:) []
 View Controller 2 canPerformUnwindSegueAction(_:from:withSender:) doUnwind: false
 View Controller 1 allowedChildViewControllersForUnwinding(from:) []
 View Controller 1 canPerformUnwindSegueAction(_:from:withSender:) doUnwind: true
 MyNavController dismiss(animated:completion:)
 MyNavController unwind(for:towardsViewController:) View Controller 1
 MyNavController popToViewController(_:animated:) View Controller 1

 
 */

class ViewController : UIViewController {
    
    @IBOutlet var lab : UILabel!
    
    override var description : String {
        get {
            if self.lab != nil {
                return "View Controller \(self.lab.text!)"
            }
            else {
                return super.description
            }
        }
    }
    
    @IBAction func doUnwind(_ sender:UIStoryboardSegue) {
        
    }
    
    override func allowedChildrenForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
        let result = super.allowedChildrenForUnwinding(from: source)
        print("\(self) \(#function) \(result)")
        return result
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        print("\(self) \(#function) \(subsequentVC)")
        super.unwind(for: unwindSegue, towards: subsequentVC)
    }
    
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        var result = super.canPerformUnwindSegueAction(action, from: fromViewController, withSender: sender)
        
        // uncomment this to do a grand unwind to root
        result = self.description == "View Controller 1"

        print("\(self) \(#function) \(action) \(result)")
        
        return result
    }
    
    override func dismiss(animated: Bool, completion: (() -> Void)?) {
        print("\(self) \(#function)")
        super.dismiss(animated:animated, completion: completion)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let result = super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        if identifier == "unwind" {
            print("\(self) \(#function) \(result)")
        }
        return result
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwind" {
            print("\(self) \(#function)")
        }
    }

    
}
