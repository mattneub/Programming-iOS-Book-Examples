

import UIKit

@objc(ViewController)
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v1 = UIView(frame:CGRect(100, 111, 132, 194))
        v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
        let v2 = UIView()
        v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
        let v3 = UIView()
        v3.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        // v3.layer.setValue("littleRedSquare", forKey:"identifier")
        
        self.view.addSubview(v1)
        v1.addSubview(v2)
        v1.addSubview(v3)
        
        v2.translatesAutoresizingMaskIntoConstraints = false
        v3.translatesAutoresizingMaskIntoConstraints = false
        
        var which : Int {return 3}
        switch which {
        case 1:
            // the old way, and this is the last time I'm going to show this
            v1.addConstraint(
                NSLayoutConstraint(item: v2,
                                   attribute: .leading,
                                   relatedBy: .equal,
                                   toItem: v1,
                                   attribute: .leading,
                                   multiplier: 1, constant: 0)
            )
            v1.addConstraint(
                NSLayoutConstraint(item: v2,
                                   attribute: .trailing,
                                   relatedBy: .equal,
                                   toItem: v1,
                                   attribute: .trailing,
                                   multiplier: 1, constant: 0)
            )
            v1.addConstraint(
                NSLayoutConstraint(item: v2,
                                   attribute: .top,
                                   relatedBy: .equal,
                                   toItem: v1,
                                   attribute: .top,
                                   multiplier: 1, constant: 0)
            )
            v2.addConstraint(
                NSLayoutConstraint(item: v2,
                                   attribute: .height,
                                   relatedBy: .equal,
                                   toItem: nil,
                                   attribute: .notAnAttribute,
                                   multiplier: 1, constant: 10)
            )
            v3.addConstraint(
                NSLayoutConstraint(item: v3,
                                   attribute: .width,
                                   relatedBy: .equal,
                                   toItem: nil,
                                   attribute: .notAnAttribute,
                                   multiplier: 1, constant: 20)
            )
            v3.addConstraint(
                NSLayoutConstraint(item: v3,
                                   attribute: .height,
                                   relatedBy: .equal,
                                   toItem: nil,
                                   attribute: .notAnAttribute,
                                   multiplier: 1, constant: 20)
            )
            v1.addConstraint(
                NSLayoutConstraint(item: v3,
                                   attribute: .trailing,
                                   relatedBy: .equal,
                                   toItem: v1,
                                   attribute: .trailing,
                                   multiplier: 1, constant: 0)
            )
            v1.addConstraint(
                NSLayoutConstraint(item: v3,
                                   attribute: .bottom,
                                   relatedBy: .equal,
                                   toItem: v1,
                                   attribute: .bottom,
                                   multiplier: 1, constant: 0)
            )
            
        case 2: // new API in iOS 9 for making constraints individually
            // and we should now be activating constraints, not adding them...
            // to a specific view
            // whereever possible, activate all the constraints at once
            NSLayoutConstraint.activate([
                v2.leadingAnchor.constraint(equalTo:v1.leadingAnchor),
                v2.trailingAnchor.constraint(equalTo:v1.trailingAnchor),
                v2.topAnchor.constraint(equalTo:v1.topAnchor),
                v2.heightAnchor.constraint(equalToConstant:10),
                v3.widthAnchor.constraint(equalToConstant:20),
                v3.heightAnchor.constraint(equalToConstant:20),
                v3.trailingAnchor.constraint(equalTo:v1.trailingAnchor),
                v3.bottomAnchor.constraint(equalTo:v1.bottomAnchor)
                ])
            
        case 3:
            
            // NSDictionaryOfVariableBindings(v2,v3) // it's a macro, no macros in Swift
            
            // let d = ["v2":v2,"v3":v3]
            // okay, that's boring...
            // let's write our own Swift NSDictionaryOfVariableBindings substitute (sort of)
            let d = dictionaryOfNames(v1,v2,v3)
            // could write activate(c + c + c) instead
            NSLayoutConstraint.activate([
                NSLayoutConstraint.constraints(withVisualFormat:
                    "H:|[v2]|", metrics: nil, views: d),
                NSLayoutConstraint.constraints(withVisualFormat:
                    "V:|[v2(10)]", metrics: nil, views: d),
                NSLayoutConstraint.constraints(withVisualFormat:
                    "H:[v3(20)]|", metrics: nil, views: d),
                // comment me out to form an ambiguity
                NSLayoutConstraint.constraints(withVisualFormat:
                    "V:[v3(20)]|", metrics: nil, views: d),
                // uncomment me to form a conflict
//                NSLayoutConstraint.constraints(withVisualFormat:
//                    "V:[v3(10)]|", metrics: nil, views: d),
                ].flatMap{$0})
        default: break
        }
        
        delay(2) {
            v1.bounds.size.width += 40
            v1.bounds.size.height -= 50
        }
        

    }


}
