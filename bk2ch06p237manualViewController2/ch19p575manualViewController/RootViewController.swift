

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
        
        let v = self.view!
        
        v.backgroundColor = .green
        
        let label = UILabel()
        v.addSubview(label)
        label.text = "Hello, World!"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo:v.centerXAnchor),
            label.centerYAnchor.constraint(equalTo:v.centerYAnchor)
            ])

    }

}
