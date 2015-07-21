

import UIKit

class LoggingView: UIView {

    override func updateConstraints() {
        super.updateConstraints()
        print("\(self) \(__FUNCTION__)\n")
    }
    
    override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
        print("\(self) \(__FUNCTION__)\n")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("\(self) \(__FUNCTION__)\n")
    }

}
