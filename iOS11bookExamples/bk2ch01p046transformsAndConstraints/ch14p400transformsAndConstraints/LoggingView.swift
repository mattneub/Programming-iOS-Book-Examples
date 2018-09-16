

import UIKit

class LoggingView: UIView {

    override func updateConstraints() {
        super.updateConstraints()
        print("\(self) \(#function)\n")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of:layer)
        print("\(self) \(#function)\n")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("\(self) \(#function)\n")
    }

}
