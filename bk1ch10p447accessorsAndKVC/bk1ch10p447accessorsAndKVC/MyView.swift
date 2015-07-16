

import UIKit

class MyView: UIView {

    override var frame : CGRect {
        didSet {
            print("the frame setter was called: \(super.frame)")
        }
    }

}
