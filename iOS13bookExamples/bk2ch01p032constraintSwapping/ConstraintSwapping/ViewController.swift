

import UIKit

// let's use this as an opportunity to explore when updateConstraints is called
class LoggingView : UIView {
    override func updateConstraints() {
        print("update constraints", self.backgroundColor as Any)
        super.updateConstraints()
    }
    override func layoutSubviews() {
        print("layout subviews", self.backgroundColor as Any)
        super.layoutSubviews()
    }
}

class ViewController: UIViewController {
    var v2 : UIView!
    var constraintsWith = [NSLayoutConstraint]()
    var constraintsWithout = [NSLayoutConstraint]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("here")
        super.touchesBegan(touches, with:event)
    }
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v1 = LoggingView()
        v1.backgroundColor = .red
        v1.translatesAutoresizingMaskIntoConstraints = false
        let v2 = LoggingView()
        v2.backgroundColor = .yellow
        v2.translatesAutoresizingMaskIntoConstraints = false
        let v3 = LoggingView()
        v3.backgroundColor = .blue
        v3.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(v1)
        self.view.addSubview(v2)
        self.view.addSubview(v3)
        
        self.v2 = v2 // retain, because we'll remove it from the interface later
        
        // construct constraints

        let c1 = NSLayoutConstraint.constraints(withVisualFormat:"H:|-(20)-[v(100)]", metrics: nil, views: ["v":v1])
        let c2 = NSLayoutConstraint.constraints(withVisualFormat:"H:|-(20)-[v(100)]", metrics: nil, views: ["v":v2])
        let c3 = NSLayoutConstraint.constraints(withVisualFormat:"H:|-(20)-[v(100)]", metrics: nil, views: ["v":v3])
        let c4 = NSLayoutConstraint.constraints(withVisualFormat:"V:|-(100)-[v(20)]", metrics: nil, views: ["v":v1])
        let c5with = NSLayoutConstraint.constraints(withVisualFormat:"V:[v1]-(20)-[v2(20)]-(20)-[v3(20)]", metrics: nil, views: ["v1":v1, "v2":v2, "v3":v3])
        let c5without = NSLayoutConstraint.constraints(withVisualFormat:"V:[v1]-(20)-[v3(20)]", metrics: nil, views: ["v1":v1, "v3":v3])
        
        // apply common constraints
        
        NSLayoutConstraint.activate([c1, c3, c4].flatMap{$0})
        
        // first set of constraints (for when v2 is present)

        self.constraintsWith.append(contentsOf:c2)
        self.constraintsWith.append(contentsOf:c5with)
        
        // second set of constraints (for when v2 is absent)
        
        self.constraintsWithout.append(contentsOf:c5without)
        

        // apply first set

        NSLayoutConstraint.activate(self.constraintsWith)
        

        
        // ignore, just testing new iOS 10 read-only properties
        do {
            let c = self.constraintsWith[0]
            print(c.firstItem as Any)
            print(c.firstAnchor)
        }
        
        print("finished viewDidLoad")
        
    }

    @IBAction func doSwap(_ sender: Any) {
        print("swapping")
        // does NOT cause `updateConstraints`
        // so it is not a signal that constraints need recalculation???
        if self.v2.superview != nil {
            self.v2.removeFromSuperview()
            NSLayoutConstraint.deactivate(self.constraintsWith)
            NSLayoutConstraint.activate(self.constraintsWithout)

        } else {
            self.view.addSubview(v2)
            NSLayoutConstraint.deactivate(self.constraintsWithout)
            NSLayoutConstraint.activate(self.constraintsWith)

        }
    }
    /*
    override func updateViewConstraints() {
        print("view controller update view contraints")
        super.updateViewConstraints()
    }
 */
}

