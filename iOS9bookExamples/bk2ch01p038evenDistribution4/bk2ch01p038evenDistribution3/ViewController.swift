

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var views : [UIView]!

    override func viewDidLoad() {
        super.viewDidLoad()
        let mainview = self.view
        
        for v in views {
            v.removeFromSuperview()
        }
        
        // give the stack view arranged subviews
        
        let sv = UIStackView(arrangedSubviews: views)
        
        // configure the stack view

        sv.axis = .Vertical
        sv.alignment = .Fill
        sv.distribution = .EqualSpacing
        
        // constrain the stack view

        sv.translatesAutoresizingMaskIntoConstraints = false
        mainview.addSubview(sv)
        NSLayoutConstraint.activateConstraints([
            sv.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor),
            sv.leadingAnchor.constraintEqualToAnchor(mainview.leadingAnchor),
            sv.trailingAnchor.constraintEqualToAnchor(mainview.trailingAnchor),
            sv.bottomAnchor.constraintEqualToAnchor(mainview.bottomAnchor),
        ])
        

    
    }



}

