

import UIKit


class ChildViewController1 : Base {
    
}

class ChildViewController2 : Base {
    
}

class Base : UIViewController {
    override func willMoveToParentViewController(parent: UIViewController!) {
        print("\(self.dynamicType) \(#function) \(parent)")
    }
    override func didMoveToParentViewController(parent: UIViewController!) {
        print("\(self.dynamicType) \(#function) \(parent)")
    }
    override func viewWillAppear(animated: Bool) {
        print("\(self.dynamicType) \(#function)")
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(animated: Bool) {
        print("\(self.dynamicType) \(#function)")
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(animated: Bool) {
        print("\(self.dynamicType) \(#function)")
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(animated: Bool) {
        print("\(self.dynamicType) \(#function)")
        super.viewDidDisappear(animated)
    }
    override func viewWillLayoutSubviews() {
        print("\(self.dynamicType) \(#function)")
    }
    override func viewDidLayoutSubviews() {
        print("\(self.dynamicType) \(#function)")
    }
    override func updateViewConstraints() {
        print("\(self.dynamicType) \(#function)")
        super.updateViewConstraints()
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        print("\(self.dynamicType) \(#function)")
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        print("\(self.dynamicType) \(#function)")
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
    }
}

