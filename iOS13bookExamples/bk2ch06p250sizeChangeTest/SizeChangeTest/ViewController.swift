
func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

import UIKit

// demonstrating that a size change without rotation is not notified to the view controller
// I find this rather odd, but I suppose it's because this is not a transition coordinator situation
// (i.e. rotation)

// also the whole launch sequence is weird
// in iOS 12 and before,
// `willTransition(to:with:)` is _not_ called, but `traitCollectionDidChange(_:)` _is_ called
// in iOS 13, it's the other way round:
// `willTransition(to:with:)` _is_ called, but `traitCollectionDidChange(_:)` is _not_ called
// I find that bizarre either way, frankly
// ??? has this changed, or did my test change? now it seems neither is called

class ViewController: UIViewController {
    
    @IBAction func doButton(_ sender: Any) {
        print(self.view.bounds.size)
        let nav = self.navigationController!
        nav.isNavigationBarHidden = !nav.isNavigationBarHidden
        delay(1) {
            print("size did in fact change")
            print(self.view.bounds.size)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function, self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(#function, self)
        print(size)
        super.viewWillTransition(to:size, with: coordinator)
        if #available(iOS 13.0, *) {
            let before = self.view.window?.windowScene?.interfaceOrientation
            print(before?.rawValue as Any)
        } else {
            let before = UIApplication.shared.statusBarOrientation
            print(before.rawValue as Any)
        }
        coordinator.animate(alongsideTransition: nil) { _ in
            if #available(iOS 13.0, *) {
                let after = self.view.window?.windowScene?.interfaceOrientation
                print(after?.rawValue as Any)
            } else {
                let after = UIApplication.shared.statusBarOrientation
                print(after.rawValue as Any)
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print(#function, self)
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print(#function, self)
        print(newCollection)
        super.willTransition(to:newCollection, with: coordinator)
    }
    
    override func updateViewConstraints() {
        print(#function, self)
        super.updateViewConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        print(#function, self)
    }
    
    override func viewDidLayoutSubviews() {
        print(#function, self)
    }
    
    
}

