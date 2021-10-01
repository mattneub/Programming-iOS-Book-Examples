

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v1 = UIView()
        v1.backgroundColor = .red
        v1.translatesAutoresizingMaskIntoConstraints = false
        
        let v2 = UIView()
        v2.backgroundColor = .green
        v2.translatesAutoresizingMaskIntoConstraints = false

        let v3 = UIView()
        v3.backgroundColor = .yellow
        v3.translatesAutoresizingMaskIntoConstraints = false
        
        
        // safe area
        
        self.view.addSubview(v1)
        let safe = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            v1.topAnchor.constraint(equalTo: safe.topAnchor),
            v1.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            v1.widthAnchor.constraint(equalToConstant: 70),
            v1.heightAnchor.constraint(equalToConstant: 70),
        ])
        
        // system spacing
        
        self.view.addSubview(v2)
        NSLayoutConstraint.activate([
            v2.topAnchor.constraint(equalTo: v1.topAnchor, constant: 10),
            // cannot omit multiplier! I regard that as a bug
            v2.leadingAnchor.constraint(equalToSystemSpacingAfter: v1.trailingAnchor, multiplier: 1),
            v2.widthAnchor.constraint(equalToConstant: 70),
            v2.heightAnchor.constraint(equalToConstant: 70),
        ])
        
        // intermediate width anchor
        
        let off = v1.leadingAnchor.anchorWithOffset(to: v2.trailingAnchor)
        self.view.addSubview(v3)
        NSLayoutConstraint.activate([
            v3.topAnchor.constraint(equalToSystemSpacingBelow: v2.bottomAnchor, multiplier: 1),
            v3.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 20),
            v3.widthAnchor.constraint(equalTo: off),
            v3.heightAnchor.constraint(equalToConstant: 70),
        ])

        
    }


}

