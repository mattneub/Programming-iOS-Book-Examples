

import UIKit

/*
We use the new iOS 8 size classes to set the constants of our constraints.
In a more elaborate situation we could actually remove and add entire constraints.
*/

class MyView: UIView {
    
    var c1 : NSLayoutConstraint!
    var c2 : NSLayoutConstraint!
        
    func configure() {
        self.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
        let v2 = UIView()
        v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
        let v3 = UIView()
        v3.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        
        v2.translatesAutoresizingMaskIntoConstraints = false
        v3.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(v2)
        self.addSubview(v3)
        
        
        self.c1 = v2.heightAnchor.constraint(equalToConstant:0) // not really
        self.c2 = v3.widthAnchor.constraint(equalToConstant:0) // not really
        NSLayoutConstraint.activate([
            c1,
            c2,
            v2.leftAnchor.constraint(equalTo:self.leftAnchor),
            v2.rightAnchor.constraint(equalTo:self.rightAnchor),
            v2.topAnchor.constraint(equalTo:self.topAnchor),
            v3.heightAnchor.constraint(equalTo:v3.widthAnchor),
            v3.rightAnchor.constraint(equalTo:self.rightAnchor),
            v3.bottomAnchor.constraint(equalTo:self.bottomAnchor),
        ])
    }
    
    override func willMove(toSuperview newSuperview: UIView!) {
        self.configure()
    }
    
    override func updateConstraints() {
        let comp = self.traitCollection.horizontalSizeClass == .compact
        let d1 : CGFloat = comp ? 10 : 40
        let d2 : CGFloat = comp ? 20 : 80
        self.c1.constant = d1
        self.c2.constant = d2
        print("\(d1) \(d2)")
        super.updateConstraints()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print("did change")
        self.setNeedsUpdateConstraints()
    }


}
