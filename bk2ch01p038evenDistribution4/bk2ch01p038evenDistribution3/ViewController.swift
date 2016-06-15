

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var views : [UIView]!

    override func viewDidLoad() {
        super.viewDidLoad()
        let mainview = self.view!
        
        for v in views {
            v.removeFromSuperview()
        }
        
        // give the stack view arranged subviews
        
        let sv = UIStackView(arrangedSubviews: views)
        
        // configure the stack view

        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .equalSpacing
        
        // constrain the stack view

        sv.translatesAutoresizingMaskIntoConstraints = false
        mainview.addSubview(sv)
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo:self.topLayoutGuide.bottomAnchor),
            sv.leadingAnchor.constraint(equalTo:mainview.leadingAnchor),
            sv.trailingAnchor.constraint(equalTo:mainview.trailingAnchor),
            sv.bottomAnchor.constraint(equalTo:mainview.bottomAnchor),
        ])
        

    
    }



}

