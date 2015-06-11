
import UIKit

class ViewController: UIViewController {
    
    var didSetup = false
    
    override func viewDidLayoutSubviews() {
        if self.didSetup {return}
        self.didSetup = true
        
        let mainview = self.view
        
        let v = UIView()
        v.backgroundColor = UIColor.redColor()
        v.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        mainview.addSubview(v)
        
        mainview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[v]-(0)-|", options: nil, metrics: nil, views: ["v":v]))
        mainview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[v]-(0)-|", options: nil, metrics: nil, views: ["v":v]))
        v.preservesSuperviewLayoutMargins = true
        
        dispatch_async(dispatch_get_main_queue()) {
            let v1 = UIView()
            v1.backgroundColor = UIColor.greenColor()
            v1.setTranslatesAutoresizingMaskIntoConstraints(false)
            v.addSubview(v1)
            v.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[v1]-|", options: nil, metrics: nil, views: ["v1":v1]))
            v.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[v1]-|", options: nil, metrics: nil, views: ["v1":v1]))
        }
        
    }
    
}

