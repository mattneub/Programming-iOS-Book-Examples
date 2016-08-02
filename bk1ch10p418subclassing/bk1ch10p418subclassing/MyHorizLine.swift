

import UIKit

class MyHorizLine: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.backgroundColor = .clear
    }
    override func draw(_ rect: CGRect) {
        let c = UIGraphicsGetCurrentContext()!
        c.moveTo(x: 0, y: 0)
        c.addLineTo(x: self.bounds.size.width, y: 0)
        c.strokePath()
    }


}
