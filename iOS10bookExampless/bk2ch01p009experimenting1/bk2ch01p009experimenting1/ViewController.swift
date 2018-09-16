

import UIKit

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let v = UIView(frame:CGRect(100,100,50,50))
        v.backgroundColor = .red // small red square
        self.view.addSubview(v) // add it to main view
    }


}

