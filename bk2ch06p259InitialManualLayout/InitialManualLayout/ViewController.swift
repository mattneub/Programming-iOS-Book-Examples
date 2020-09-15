

import UIKit

class ViewController: UIViewController {

    var which : Int { return 3 }
    override func viewDidLoad() {
        super.viewDidLoad()
        switch which {
        case 0:
            let lab = UILabel()
            lab.text = "Hello"
            lab.sizeToFit()
            lab.frame.origin.y = self.view.bounds.height - lab.frame.height
            self.view.addSubview(lab)
        case 1:
            let lab = UILabel()
            lab.text = "Hello"
            self.view.addSubview(lab)
            lab.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                lab.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                lab.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        case 3:
            self.lab = UILabel()
            self.lab.text = "Hello"
            self.lab.sizeToFit()
            self.view.addSubview(lab)
        default: break
        }
    }
    
    var lab : UILabel!
    override func viewWillLayoutSubviews() {
        switch which {
        case 2:
            if self.lab == nil {
                self.lab = UILabel()
                self.lab.text = "Hello"
                self.lab.sizeToFit()
                self.view.addSubview(lab)
            }
            self.lab.frame.origin.y = self.view.bounds.height - self.lab.frame.height
        case 3:
            self.lab.frame.origin.y = self.view.bounds.height - self.lab.frame.height
        default: break
        }
    }


}

