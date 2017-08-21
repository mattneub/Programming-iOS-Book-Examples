

import UIKit


class MyView : UIView {
    @IBInspectable var w : CGFloat = 100
    override var intrinsicContentSize: CGSize {
        return CGSize(width:self.w, height:20)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

