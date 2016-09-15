

import UIKit

class RootViewController: UIViewController {
    
    let which = 2
    
    override func loadView() {
        let v = UIView()
        v.backgroundColor = UIColor.greenColor()
        self.view = v
        let label = UILabel()
        v.addSubview(label)
        label.text = "Hello, World!"

        switch which {
        case 1:
            label.autoresizingMask = [
                .FlexibleTopMargin,
                .FlexibleLeftMargin,
                .FlexibleBottomMargin,
                .FlexibleRightMargin]
            label.sizeToFit()
            label.center = CGPointMake(v.bounds.midX, v.bounds.midY)
            label.frame.makeIntegralInPlace()

        case 2:
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activateConstraints([
                label.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor),
                label.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor),
                ])
        default: break
        }
    }

}
