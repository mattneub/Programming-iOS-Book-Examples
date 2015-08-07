import UIKit

class MyView : UIView {
    
    override func layoutSubviews() {
        print(__FUNCTION__)
        super.layoutSubviews()
    }
    
    override func updateConstraints() {
        print(__FUNCTION__)
        super.updateConstraints()
    }
    
}
