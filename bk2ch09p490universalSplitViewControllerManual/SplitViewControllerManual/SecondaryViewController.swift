

import UIKit

class SecondaryViewController : UIViewController {
    
    // configure our interface
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        let b = UIButton(type:.system)
        b.setTitle("Configure", for:.normal) // normal
        b.backgroundColor = .yellow
        b.addTarget(self, action: #selector(callShowHide), for: .touchUpInside)
        self.view.addSubview(b)
        b.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat:"H:[b]-|", metrics: nil, views: ["b":b]),
            NSLayoutConstraint.constraints(withVisualFormat:"V:[b]-|", metrics: nil, views: ["b":b])
            ].flatMap{$0})
    }
    
    @objc func callShowHide(_ sender: Any?) {
        // this intermediate method is unnecessary; it's just so I can log the call
        print("calling showHide on self")
        self.showHide(sender)
    }
}
