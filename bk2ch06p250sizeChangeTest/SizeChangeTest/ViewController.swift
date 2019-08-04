
func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

import UIKit

// demonstrating that a size change without rotation is not notified to the view controller
// I find this rather odd, but I suppose it's because this is not a transition coordinator situation
// (i.e. rotation)

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
        let sborBefore = self.view.window?.windowScene?.interfaceOrientation
        print(sborBefore?.rawValue as Any)
        coordinator.animate(alongsideTransition: nil) { _ in
            let sborAfter = self.view.window?.windowScene?.interfaceOrientation
            print(sborAfter?.rawValue as Any)
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

