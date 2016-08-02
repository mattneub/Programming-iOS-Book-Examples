

import UIKit

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let mainview = self.view! // new in Swift 3 of 6/6, IUO does not propagate
        let v = UIView(frame:CGRect(100,100,50,50))
        v.backgroundColor = .red // small red square
        mainview.addSubview(v) // add it to main view
    }


}

