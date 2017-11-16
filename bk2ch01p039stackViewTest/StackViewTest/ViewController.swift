

import UIKit


class MyView : UIView {
    @IBInspectable var w : CGFloat = 100
    override var intrinsicContentSize: CGSize {
        return CGSize(width:self.w, height:20)
    }
}

class ViewController: UIViewController {



}

