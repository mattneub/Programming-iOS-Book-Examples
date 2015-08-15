

import UIKit


class ChildViewController1 : Base {
    
}

class ChildViewController2 : Base {
    
}

class Base : UIViewController {
    override func willMoveToParentViewController(parent: UIViewController!) {
        print("\(self.dynamicType) \(__FUNCTION__) \(parent)")
    }
    override func didMoveToParentViewController(parent: UIViewController!) {
        print("\(self.dynamicType) \(__FUNCTION__) \(parent)")
    }
    override func viewWillAppear(animated: Bool) {
        print("\(self.dynamicType) \(__FUNCTION__)")
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(animated: Bool) {
        print("\(self.dynamicType) \(__FUNCTION__)")
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(animated: Bool) {
        print("\(self.dynamicType) \(__FUNCTION__)")
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(animated: Bool) {
        print("\(self.dynamicType) \(__FUNCTION__)")
        super.viewDidDisappear(animated)
    }
    override func viewWillLayoutSubviews() {
        print("\(self.dynamicType) \(__FUNCTION__)")
    }
    override func viewDidLayoutSubviews() {
        print("\(self.dynamicType) \(__FUNCTION__)")
    }
    override func updateViewConstraints() {
        print("\(self.dynamicType) \(__FUNCTION__)")
        super.updateViewConstraints()
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        print("\(self.dynamicType) \(__FUNCTION__)")
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        print("\(self.dynamicType) \(__FUNCTION__)")
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
    }
}

