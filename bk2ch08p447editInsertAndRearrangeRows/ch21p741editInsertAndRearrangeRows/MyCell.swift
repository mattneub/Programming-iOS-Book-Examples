
import UIKit

class MyCell : UITableViewCell {
    @IBOutlet weak var textField : UITextField!
    override func didTransitionToState(state: UITableViewCellStateMask) {
        // well, I think I had this wrong all these years
        if state & UITableViewCellStateMask.ShowingEditControlMask {
            self.textField.enabled = true
        }
        else {
            self.textField.enabled = false
        }
    }
}
