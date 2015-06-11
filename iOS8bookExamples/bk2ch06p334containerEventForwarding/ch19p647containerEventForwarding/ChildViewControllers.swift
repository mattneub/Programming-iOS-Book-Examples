

import UIKit


class ChildViewController1 : Base {
    
}

class ChildViewController2 : Base {
    
}

class Base : UIViewController {
    override func willMoveToParentViewController(parent: UIViewController!) {
        println("\(self) \(__FUNCTION__) \(parent)")
    }
    override func didMoveToParentViewController(parent: UIViewController!) {
        println("\(self) \(__FUNCTION__) \(parent)")
    }
    override func viewWillAppear(animated: Bool) {
        println("\(self) \(__FUNCTION__)")
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(animated: Bool) {
        println("\(self) \(__FUNCTION__)")
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(animated: Bool) {
        println("\(self) \(__FUNCTION__)")
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(animated: Bool) {
        println("\(self) \(__FUNCTION__)")
        super.viewDidDisappear(animated)
    }
    override func viewWillLayoutSubviews() {
        println("\(self) \(__FUNCTION__)")
    }
    override func viewDidLayoutSubviews() {
        println("\(self) \(__FUNCTION__)")
    }
    override func updateViewConstraints() {
        println("\(self) \(__FUNCTION__)")
        super.updateViewConstraints()
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        println("\(self) \(__FUNCTION__)")
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        println("\(self) \(__FUNCTION__)")
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
    }
}

