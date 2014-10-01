
import UIKit

class MyCell : UITableViewCell {
    @IBOutlet weak var textField : UITextField!
    override func didTransitionToState(state: UITableViewCellStateMask) {
        // well, I think I had this wrong all these years
        // but sheesh, Swift numerics are getting harder and harder
        let editing = UITableViewCellStateMask.ShowingEditControlMask.rawValue
        if state.rawValue & editing != 0 {
            self.textField.enabled = true
        }
        else {
            self.textField.enabled = false
        }
    }
}
