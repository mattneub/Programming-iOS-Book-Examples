import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var lab : UILabel!
    
    @IBOutlet weak var con1: NSLayoutConstraint!
    @IBOutlet weak var con2: NSLayoutConstraint!

    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        println("vc did change")
        let tc = self.traitCollection
        if tc.horizontalSizeClass == .Regular {
            println("regular")
            if self.con1 != nil {
                println("changing constraints")
                self.view.removeConstraints([self.con1, self.con2])
                self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[tg]-[lab]", options: nil, metrics: nil, views: ["tg":self.topLayoutGuide, "lab":self.lab]))
                self.view.addConstraint(NSLayoutConstraint(item: self.lab, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
                let sz = self.lab.font.pointSize * 2
                self.lab.font = self.lab.font.fontWithSize(sz)
            }
        }
    }
    
}

