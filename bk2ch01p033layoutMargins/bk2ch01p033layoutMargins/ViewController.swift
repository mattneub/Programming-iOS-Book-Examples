
import UIKit

class ViewController: UIViewController {
    
    var didSetup = false
    
    
    override func viewDidLayoutSubviews() {
        if self.didSetup {return}
        self.didSetup = true
        
        let mainview = self.view!
        
        let v = UIView()
        v.backgroundColor = UIColor.red()
        v.translatesAutoresizingMaskIntoConstraints = false
        
        mainview.addSubview(v)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat:"H:|-(0)-[v]-(0)-|", metrics: nil, views: ["v":v]),
            NSLayoutConstraint.constraints(withVisualFormat:"V:|-(0)-[v]-(0)-|", metrics: nil, views: ["v":v])
            ].flatMap{$0})
        
        // experiment by commenting out this line
        v.preservesSuperviewLayoutMargins = true
        
        let v1 = UIView()
        v1.backgroundColor = UIColor.green()
        v1.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(v1)

        var which : Int {return 1}
        switch which {
            
        case 1:
            // no longer need delayed performance here
            NSLayoutConstraint.activate([
                NSLayoutConstraint.constraints(withVisualFormat:"H:|-[v1]-|", metrics: nil, views: ["v1":v1]),
                NSLayoutConstraint.constraints(withVisualFormat:"V:|-[v1]-|", metrics: nil, views: ["v1":v1])
                ].flatMap{$0})
            
        case 2:
            // new notation treats margins as a pseudoview (UILayoutGuide)
            NSLayoutConstraint.activate([
                v1.topAnchor.constraint(equalTo:v.layoutMarginsGuide.topAnchor),
                v1.bottomAnchor.constraint(equalTo:v.layoutMarginsGuide.bottomAnchor),
                v1.trailingAnchor.constraint(equalTo:v.layoutMarginsGuide.trailingAnchor),
                v1.leadingAnchor.constraint(equalTo:v.layoutMarginsGuide.leadingAnchor)
                ])
            
        case 3:
            // new kind of margin, "readable content"
            // particularly dramatic on iPad in landscape
            NSLayoutConstraint.activate([
                v1.topAnchor.constraint(equalTo:v.readableContentGuide.topAnchor),
                v1.bottomAnchor.constraint(equalTo:v.readableContentGuide.bottomAnchor),
                v1.trailingAnchor.constraint(equalTo:v.readableContentGuide.trailingAnchor),
                v1.leadingAnchor.constraint(equalTo:v.readableContentGuide.leadingAnchor)
                ])

        default:break
        }
        
    }
    
}

