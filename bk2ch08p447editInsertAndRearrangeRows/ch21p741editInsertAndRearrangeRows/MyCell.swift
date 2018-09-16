
import UIKit

class MyCell : UITableViewCell {
    @IBOutlet weak var textField : UITextField!
    override func didTransition(to state: UITableViewCell.StateMask) {
        self.textField.isEnabled = state.contains(.showingEditControl)
        super.didTransition(to:state)
    }
}
