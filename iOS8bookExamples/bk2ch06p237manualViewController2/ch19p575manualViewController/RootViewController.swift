

import UIKit

class RootViewController: UIViewController {
    
    let which = 1
    
    override func loadView() {
        switch which {
        case 1:
            let v = UIView()
            self.view = v

        case 2: fallthrough
        default:
            // if you don't create a custom view in code...
            // ... then either don't implement loadView() or,
            // if you do, then call super so that the view is created
            super.loadView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = self.view
        
        v.backgroundColor = UIColor.greenColor()
        
        let label = UILabel()
        v.addSubview(label)
        label.text = "Hello, World!"
        
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

    }

}
