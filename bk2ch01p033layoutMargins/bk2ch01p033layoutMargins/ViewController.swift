
import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

class MyView : UIView {
    override func safeAreaInsetsDidChange() {
        print(self.backgroundColor!, "safe area changed to", self.safeAreaInsets)
        super.safeAreaInsetsDidChange()
    }
    override func didMoveToSuperview() {
        print(self.backgroundColor!, "did move to superview")
    }
    override func layoutSubviews() {
        print(self.backgroundColor!, "layoutSubviews")
        super.layoutSubviews()
    }
}


class ViewController: UIViewController {
    
    var didSetup = false
    override func viewDidLayoutSubviews() {
        if self.didSetup {return}
        self.didSetup = true
        
        // for a good time, uncomment this
        // self.additionalSafeAreaInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
                
        let redView = MyView()
        redView.backgroundColor = .red
        redView.translatesAutoresizingMaskIntoConstraints = false
        print("red view default margins", redView.directionalLayoutMargins)
        
        self.view.addSubview(redView)
        
        var which2 : Int { return 0 }
        switch which2 {
        case 0:
            NSLayoutConstraint.activate([
                NSLayoutConstraint.constraints(withVisualFormat:"H:|-(0)-[v]-(0)-|", metrics: nil, views: ["v":redView]),
                NSLayoutConstraint.constraints(withVisualFormat:"V:|-(0)-[v]-(0)-|", metrics: nil, views: ["v":redView])
                ].flatMap{$0})
        case 1:
            // trying to figure out how use visual layout format to pin to safe area
            // so far, I haven't found a way; I've filed a bug
            NSLayoutConstraint.activate([
                NSLayoutConstraint.constraints(withVisualFormat:"H:|-(0)-[v]-(0)-|", metrics: nil, views: ["v":redView]),
                NSLayoutConstraint.constraints(withVisualFormat:"V:[s]-[v]-(0)-|", metrics: nil, views: ["v":redView, "s":self.view.safeAreaLayoutGuide])
                ].flatMap{$0})
        default: break
        }
        
        // experiment by commenting out this line
        // v.preservesSuperviewLayoutMargins = true
        delay(1) {
            print("delay 1")
            print("main view layout margins", self.view.layoutMargins)
            // 20 on iPad Pro large
            // 20 on iPhone 6s Plus
            // 20 on iPad Air 2
            // 16 on iPhone 5s
            // 16 on iPhone 6s
            print("red layoutMargins", redView.layoutMargins)
            print("red safe", redView.safeAreaInsets)
            // print(v.window!.layoutMargins)
        }
        
        // return;
        
        let greenView = MyView()
        greenView.backgroundColor = .green
        greenView.translatesAutoresizingMaskIntoConstraints = false
        redView.addSubview(greenView)

        var which : Int {return 1}
        switch which {
            
        case 1:
            // display margins
            NSLayoutConstraint.activate([
                NSLayoutConstraint.constraints(withVisualFormat:"H:|-[v1]-|", metrics: nil, views: ["v1":greenView]),
                NSLayoutConstraint.constraints(withVisualFormat:"V:|-[v1]-|", metrics: nil, views: ["v1":greenView])
                ].flatMap{$0})
            
        case 2:
            // test underlap of margin (use logging)
            NSLayoutConstraint.activate([
                NSLayoutConstraint.constraints(withVisualFormat:"H:|-10-[v1]-|", metrics: nil, views: ["v1":greenView]),
                NSLayoutConstraint.constraints(withVisualFormat:"V:|-[v1]-|", metrics: nil, views: ["v1":greenView])
                ].flatMap{$0})

        case 3:
            // display margins; new notation treats margins as a pseudoview (UILayoutGuide)
            NSLayoutConstraint.activate([
                greenView.topAnchor.constraint(equalTo:redView.layoutMarginsGuide.topAnchor),
                greenView.bottomAnchor.constraint(equalTo:redView.layoutMarginsGuide.bottomAnchor),
                greenView.trailingAnchor.constraint(equalTo:redView.layoutMarginsGuide.trailingAnchor),
                greenView.leadingAnchor.constraint(equalTo:redView.layoutMarginsGuide.leadingAnchor)
                ])
            
        case 4:
            // display safe area
            NSLayoutConstraint.activate([
                greenView.topAnchor.constraint(equalTo:redView.safeAreaLayoutGuide.topAnchor),
                greenView.bottomAnchor.constraint(equalTo:redView.safeAreaLayoutGuide.bottomAnchor),
                greenView.trailingAnchor.constraint(equalTo:redView.safeAreaLayoutGuide.trailingAnchor),
                greenView.leadingAnchor.constraint(equalTo:redView.safeAreaLayoutGuide.leadingAnchor)
                ])

            
        case 5:
            // new kind of margin, "readable content"
            // particularly dramatic on iPad in landscape
            NSLayoutConstraint.activate([
                greenView.topAnchor.constraint(equalTo:redView.readableContentGuide.topAnchor),
                greenView.bottomAnchor.constraint(equalTo:redView.readableContentGuide.bottomAnchor),
                greenView.trailingAnchor.constraint(equalTo:redView.readableContentGuide.trailingAnchor),
                greenView.leadingAnchor.constraint(equalTo:redView.readableContentGuide.leadingAnchor)
                ])

        default:break
        }
        
        print("green safe", greenView.safeAreaInsets) // before layout
        
        // experiment; let's give the red view big margins
//        redView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 40, leading: 40, bottom: 40, trailing: 40)
//        greenView.preservesSuperviewLayoutMargins = true
        
        // experiment: turn off safe area affecting margins
        // redView.insetsLayoutMarginsFromSafeArea = false
        
        // experiment: let's give the main view big margins
//        self.view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 40, leading: 40, bottom: 40, trailing: 40)
//        redView.preservesSuperviewLayoutMargins = true
        
        // experiment: let's give the main view zero margins
//        self.view.directionalLayoutMargins = .zero // no effect; we get 20,16,0,16 - unless we also turn off the system minimum
//        self.viewRespectsSystemMinimumLayoutMargins = false // that works, except that of course we still have a top of 20 because of the safe area
//        self.view.insetsLayoutMarginsFromSafeArea = false // that gives absolute zero
        
        delay(2) {
            print("delay 2")
            print("green top", greenView.frame.origin.y)
            print("green safe", greenView.safeAreaInsets)
            // print("green safe", greenView.safeAreaLayoutGuide)
            // print(redView.constraintsAffectingLayout(for: .vertical))
            
            print("v.c. sys min", self.systemMinimumLayoutMargins)
            print("v.c. sys min applies", self.viewRespectsSystemMinimumLayoutMargins)
            print("red marg", redView.layoutMargins)
            print("green marg", greenView.layoutMargins)
        }
        
        // safe area changes before layoutSubviews is called
        // at that point, they both propagate down
        
        
    }
    
}

