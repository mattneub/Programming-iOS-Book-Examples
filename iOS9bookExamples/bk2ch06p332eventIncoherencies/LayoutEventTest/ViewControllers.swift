

import UIKit

class Base : UIViewController {
    override func willMoveToParentViewController(parent: UIViewController!) {
        print("\(self) \(#function) \(parent)")
    }
    override func didMoveToParentViewController(parent: UIViewController!) {
        print("\(self) \(#function) \(parent)")
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self) \(#function)")
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self) \(#function)")
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(self) \(#function)")
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(self) \(#function)")
    }
    override func viewWillLayoutSubviews() {
        print("\(self) \(#function)")
    }
    override func viewDidLayoutSubviews() {
        print("\(self) \(#function)")
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        print("\(self) \(#function)")
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        print("\(self) \(#function)")
    }
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        print("\(self) \(#function)")
    }
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        print("\(self) \(#function)")
    }
}

class ViewController : Base {
    
}

class ViewController2 : Base {
    
}

