import UIKit

class ViewController: UIViewController {
    var lab : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let lab = UILabel()
        lab.text = ""
        lab.frame.origin = CGPointMake(100,100)
        self.view.addSubview(lab)
        self.lab = lab
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.lab.text = self.tabBarItem.title
        self.lab.sizeToFit()
    }
}
