

import UIKit

class LoggingView: UIView {

    override func updateConstraints() {
        super.updateConstraints()
        print("\(self) \(#function)\n")
    }
    
    override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
        print("\(self) \(#function)\n")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("\(self) \(#function)\n")
    }

}
