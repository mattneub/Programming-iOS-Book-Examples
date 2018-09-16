

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var views : [UIView]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.view.addSubview(sv)
        let marg = self.view.layoutMarginsGuide
        let safe = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo:safe.topAnchor),
            sv.leadingAnchor.constraint(equalTo:marg.leadingAnchor),
            sv.trailingAnchor.constraint(equalTo:marg.trailingAnchor),
            sv.bottomAnchor.constraint(equalTo:self.view.bottomAnchor),
        ])
        

    
    }



}

