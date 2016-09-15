
import UIKit

class MyCell : UITableViewCell {
    @IBOutlet weak var textField : UITextField!
    override func didTransitionToState(state: UITableViewCellStateMask) {
        self.textField.enabled = state.contains(.ShowingEditControlMask)
        super.didTransitionToState(state)
    }
}
