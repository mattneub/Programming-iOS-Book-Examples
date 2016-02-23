import UIKit

class MyView : UIView {
    
    override func layoutSubviews() {
        print(#function)
        super.layoutSubviews()
    }
    
    override func updateConstraints() {
        print(#function)
        super.updateConstraints()
    }
    
}
