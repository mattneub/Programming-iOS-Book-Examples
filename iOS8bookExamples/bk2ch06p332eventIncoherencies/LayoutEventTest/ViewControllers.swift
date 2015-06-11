

import UIKit

class Base : UIViewController {
    override func willMoveToParentViewController(parent: UIViewController!) {
        println("\(self) \(__FUNCTION__) \(parent)")
    }
    override func didMoveToParentViewController(parent: UIViewController!) {
        println("\(self) \(__FUNCTION__) \(parent)")
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("\(self) \(__FUNCTION__)")
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("\(self) \(__FUNCTION__)")
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        println("\(self) \(__FUNCTION__)")
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        println("\(self) \(__FUNCTION__)")
    }
    override func viewWillLayoutSubviews() {
        println("\(self) \(__FUNCTION__)")
    }
    override func viewDidLayoutSubviews() {
        println("\(self) \(__FUNCTION__)")
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        println("\(self) \(__FUNCTION__)")
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        println("\(self) \(__FUNCTION__)")
    }
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        println("\(self) \(__FUNCTION__)")
    }
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        println("\(self) \(__FUNCTION__)")
    }
}

class ViewController : Base {
    
}

class ViewController2 : Base {
    
}

