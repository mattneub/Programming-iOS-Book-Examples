

import UIKit

class RootViewController: UIViewController {
    
    let which = 1
    
    override func loadView() {
        let v = UIView()
        v.backgroundColor = UIColor.greenColor()
        self.view = v
        let label = UILabel()
        v.addSubview(label)
        label.text = "Hello, World!"

        switch which {
        case 1:
            label.autoresizingMask =
                .FlexibleTopMargin |
                .FlexibleLeftMargin |
                .FlexibleBottomMargin |
                .FlexibleRightMargin
            label.sizeToFit()
            label.center = CGPointMake(v.bounds.midX, v.bounds.midY)
            label.frame.integerize()

        case 2:
            label.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.view.addConstraint(
                NSLayoutConstraint(item: label,
                    attribute: .CenterX,
                    relatedBy: .Equal,
                    toItem: self.view,
                    attribute: .CenterX,
                    multiplier: 1, constant: 0))
            self.view.addConstraint(
                NSLayoutConstraint(item: label,
                    attribute: .CenterY,
                    relatedBy: .Equal,
                    toItem: self.view,
                    attribute: .CenterY,
                    multiplier: 1, constant: 0))
        default: break
        }
    }

}
