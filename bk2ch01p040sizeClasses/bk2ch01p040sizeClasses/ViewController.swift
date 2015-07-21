import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var lab : UILabel!
    
    @IBOutlet weak var con1: NSLayoutConstraint!
    @IBOutlet weak var con2: NSLayoutConstraint!

    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        print("vc did change")
        let tc = self.traitCollection
        if tc.horizontalSizeClass == .Regular {
            print("regular")
            if self.con1 != nil {
                print("changing constraints")
                NSLayoutConstraint.deactivateConstraints([self.con1, self.con2])
                NSLayoutConstraint.activateConstraints([
                    NSLayoutConstraint.constraintsWithVisualFormat("V:[tg]-[lab]", options: [], metrics: nil, views: ["tg":self.topLayoutGuide, "lab":self.lab]),
                    [self.lab.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor)]
                    ].flatMap{$0})
                let sz = self.lab.font.pointSize * 2
                self.lab.font = self.lab.font.fontWithSize(sz)
            }
        }
    }
    
}

