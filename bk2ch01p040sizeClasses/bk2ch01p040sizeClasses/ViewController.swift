import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var lab : UILabel!
    
    @IBOutlet weak var con1: NSLayoutConstraint!
    @IBOutlet weak var con2: NSLayoutConstraint!
    
    // iPad interface is different; fix on launch
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print("trait collection did change")
        let tc = self.traitCollection
        print(tc)
        if tc.horizontalSizeClass == .regular {
            print("regular")
            if self.con1 != nil {
                print("changing constraints")
                NSLayoutConstraint.deactivate([self.con1, self.con2])
                NSLayoutConstraint.activate([
                    self.lab.topAnchor.constraint(
                        equalToSystemSpacingBelow: self.view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
                    self.lab.centerXAnchor.constraint(equalTo:self.view.centerXAnchor)
                    ])
                let sz = self.lab.font.pointSize * 2
                self.lab.font = self.lab.font.withSize(sz)
            }
        }
    }
    
}

