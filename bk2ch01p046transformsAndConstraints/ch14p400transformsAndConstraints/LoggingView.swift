

import UIKit

class LoggingView: UIView {

    override func updateConstraints() {
        super.updateConstraints()
        println("\(self) \(__FUNCTION__)\n")
    }
    
    override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
        println("\(self) \(__FUNCTION__)\n")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        println("\(self) \(__FUNCTION__)\n")
    }

}
