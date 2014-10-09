

import UIKit

class DetailViewController: UIViewController {
    
    var lab : UILabel!
    var boy : String = "" {
        didSet {
            if self.lab != nil {
                self.lab.text = self.boy
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        let lab = UILabel(frame:CGRectMake(100,100,100,30))
        self.view.addSubview(lab)
        self.lab = lab
        self.lab.text = self.boy
    }

}
