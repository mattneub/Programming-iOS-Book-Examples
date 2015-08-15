

import UIKit

class Base : UIViewController {
    override func willMoveToParentViewController(parent: UIViewController!) {
        print("\(self) \(__FUNCTION__) \(parent)")
    }
    override func didMoveToParentViewController(parent: UIViewController!) {
        print("\(self) \(__FUNCTION__) \(parent)")
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self) \(__FUNCTION__)")
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self) \(__FUNCTION__)")
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(self) \(__FUNCTION__)")
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(self) \(__FUNCTION__)")
    }
    override func viewWillLayoutSubviews() {
        print("\(self) \(__FUNCTION__)")
    }
    override func viewDidLayoutSubviews() {
        print("\(self) \(__FUNCTION__)")
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        print("\(self) \(__FUNCTION__)")
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        print("\(self) \(__FUNCTION__)")
    }
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        print("\(self) \(__FUNCTION__)")
    }
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        print("\(self) \(__FUNCTION__)")
    }
}

class ViewController : Base {
    
}

class ViewController2 : Base {
    
}

