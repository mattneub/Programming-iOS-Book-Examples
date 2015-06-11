import UIKit

class MyView : UIView {
    
    override func layoutSubviews() {
        println(__FUNCTION__)
        super.layoutSubviews()
    }
    
    override func updateConstraints() {
        println(__FUNCTION__)
        super.updateConstraints()
    }
    
}
