

import UIKit

class MyBoundedLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        context.stroke(self.bounds.insetBy(dx: 1.0, dy: 1.0))
        super.drawText(in: rect.insetBy(dx: 5.0, dy: 5.0))
    }

}
