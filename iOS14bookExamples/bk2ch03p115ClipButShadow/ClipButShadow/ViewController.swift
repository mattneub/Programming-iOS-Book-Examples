

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var iv: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    var didLayout = false
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.didLayout { return }
        self.didLayout = true
        let v = UIView()
        v.backgroundColor = .black
        v.frame = iv.frame
        v.clipsToBounds = false
        v.layer.shadowColor = UIColor.gray.cgColor
        v.layer.shadowOffset = CGSize(width: 20, height: 20)
        v.layer.shadowOpacity = 0.4
        self.view.insertSubview(v, belowSubview: iv)
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo:iv.topAnchor),
            v.bottomAnchor.constraint(equalTo:iv.bottomAnchor),
            v.leadingAnchor.constraint(equalTo:iv.leadingAnchor),
            v.trailingAnchor.constraint(equalTo:iv.trailingAnchor),
        ])
    }
}

