

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

        let v1leading = v1.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20)
        let v1width = v1.widthAnchor.constraint(equalToConstant: 100)
        let v2leading = v2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20)
        let v2width = v2.widthAnchor.constraint(equalToConstant: 100)
        let v3leading = v3.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20)
        let v3width = v3.widthAnchor.constraint(equalToConstant: 100)
        let v1top = v1.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100)
        let v1height = v1.heightAnchor.constraint(equalToConstant: 20)
        let v2height = v2.heightAnchor.constraint(equalToConstant: 20)
        let v3height = v3.heightAnchor.constraint(equalToConstant: 20)
        // when v2 is present
        let v1tov2 = v1.bottomAnchor.constraint(equalTo: v2.topAnchor, constant: -20)
        let v2tov3 = v2.bottomAnchor.constraint(equalTo: v3.topAnchor, constant: -20)
        // when v2 is absent
        let v1tov3 = v1.bottomAnchor.constraint(equalTo: v3.topAnchor, constant: -20)

        // apply common constraints
        
        NSLayoutConstraint.activate([
            v1leading, v1width, v3leading, v3width, v1top, v1height, v3height
        ])
        
        // first set of constraints (for when v2 is present)

        self.constraintsWith = [
            v2leading, v2width, v2height, v1tov2, v2tov3
        ]
        
        // second set of constraints (for when v2 is absent)
        
        self.constraintsWithout = [
            v1tov3
        ]

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

