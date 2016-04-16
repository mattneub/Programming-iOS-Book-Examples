

import UIKit

class SecondaryViewController : UIViewController {
    
    // configure our interface
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red()
        let b = UIButton(type:.system)
        b.setTitle("Configure", for: []) // normal
        b.backgroundColor = UIColor.yellow()
        b.addTarget(self, action: #selector(callShowHide), for: .touchUpInside)
        self.view.addSubview(b)
        b.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat:"H:[b]-|", options: [], metrics: nil, views: ["b":b]),
            NSLayoutConstraint.constraints(withVisualFormat:"V:[b]-|", options: [], metrics: nil, views: ["b":b])
            ].flatten().map{$0})
    }
    
    func callShowHide(_ sender:AnyObject?) {
        // this intermediate method is unnecessary; it's just so I can log the call
        print("calling showHide on self")
        self.showHide(sender)
    }
}
