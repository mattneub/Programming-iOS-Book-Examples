

import UIKit

class MyView: UIView {

    override var frame : CGRect {
        didSet {
            println("the frame setter was called: \(super.frame)")
        }
    }

}
