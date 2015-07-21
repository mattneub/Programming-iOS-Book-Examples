
import UIKit

class ViewController: UIViewController {
    
    var didSetup = false
    
    let which = 2
    
    override func viewDidLayoutSubviews() {
        if self.didSetup {return}
        self.didSetup = true
        
        let mainview = self.view
        
        let v = UIView()
        v.backgroundColor = UIColor.redColor()
        v.translatesAutoresizingMaskIntoConstraints = false
        
        mainview.addSubview(v)
        
        NSLayoutConstraint.activateConstraints([
            NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[v]-(0)-|", options: [], metrics: nil, views: ["v":v]),
            NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[v]-(0)-|", options: [], metrics: nil, views: ["v":v])
            ].flatMap{$0})
        
        // experiment by commenting out this line
        v.preservesSuperviewLayoutMargins = true
        
        let v1 = UIView()
        v1.backgroundColor = UIColor.greenColor()
        v1.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(v1)

        
        switch which {
            
        case 1:
            // no longer need delayed performance here
            NSLayoutConstraint.activateConstraints([
                NSLayoutConstraint.constraintsWithVisualFormat("H:|-[v1]-|", options: [], metrics: nil, views: ["v1":v1]),
                NSLayoutConstraint.constraintsWithVisualFormat("V:|-[v1]-|", options: [], metrics: nil, views: ["v1":v1])
                ].flatMap{$0})
            
        case 2:
            // new notation treats margins as a pseudoview (UILayoutGuide)
            NSLayoutConstraint.activateConstraints([
                v1.topAnchor.constraintEqualToAnchor(v.layoutMarginsGuide.topAnchor),
                v1.bottomAnchor.constraintEqualToAnchor(v.layoutMarginsGuide.bottomAnchor),
                v1.rightAnchor.constraintEqualToAnchor(v.layoutMarginsGuide.rightAnchor),
                v1.leftAnchor.constraintEqualToAnchor(v.layoutMarginsGuide.leftAnchor)
                ])
            
        case 3:
            // new kind of margin, "readable content"
            // particularly dramatic on iPad in landscape
            NSLayoutConstraint.activateConstraints([
                v1.topAnchor.constraintEqualToAnchor(v.readableContentGuide.topAnchor),
                v1.bottomAnchor.constraintEqualToAnchor(v.readableContentGuide.bottomAnchor),
                v1.rightAnchor.constraintEqualToAnchor(v.readableContentGuide.rightAnchor),
                v1.leftAnchor.constraintEqualToAnchor(v.readableContentGuide.leftAnchor)
                ])

        default:break
        }
        
    }
    
}

