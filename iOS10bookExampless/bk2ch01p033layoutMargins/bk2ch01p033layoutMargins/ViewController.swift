
import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController: UIViewController {
    
    var didSetup = false
    
    
    override func viewDidLayoutSubviews() {
        if self.didSetup {return}
        self.didSetup = true
                
        // ok, I proved what I wanted to prove: it really _is_ whether it's a vc's main view
//        let vc = UIViewController()
//        self.addChildViewController(vc)
        
         let v = UIView()
//        let v = vc.view!
        v.backgroundColor = .red
        v.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(v)
        
        // vc.didMove(toParentViewController: self)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat:"H:|-(0)-[v]-(0)-|", metrics: nil, views: ["v":v]),
            NSLayoutConstraint.constraints(withVisualFormat:"V:|-(0)-[v]-(0)-|", metrics: nil, views: ["v":v])
            ].flatMap{$0})
        
        // experiment by commenting out this line
        // v.preservesSuperviewLayoutMargins = true
        delay(1) {
            // print(self.view.layoutMargins)
            // 20 on iPad Pro large
            // 20 on iPhone 6s Plus
            // 20 on iPad Air 2
            // 16 on iPhone 5s
            // 16 on iPhone 6s
            print(v.layoutMargins)
            // print(v.window!.layoutMargins)
        }
        
        let v1 = UIView()
        v1.backgroundColor = .green
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

