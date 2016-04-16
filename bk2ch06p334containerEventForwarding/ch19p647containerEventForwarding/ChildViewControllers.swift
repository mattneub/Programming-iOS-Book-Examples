

import UIKit


class ChildViewController1 : Base {
    
}

class ChildViewController2 : Base {
    
}

class Base : UIViewController {
    override func willMove(toParentViewController parent: UIViewController!) {
        print("\(self.dynamicType) \(#function) \(parent)")
    }
    override func didMove(toParentViewController parent: UIViewController!) {
        print("\(self.dynamicType) \(#function) \(parent)")
    }
    override func viewWillAppear(_ animated: Bool) {
        print("\(self.dynamicType) \(#function)")
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        print("\(self.dynamicType) \(#function)")
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("\(self.dynamicType) \(#function)")
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
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
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("\(self.dynamicType) \(#function)")
        super.viewWillTransition(to: size, with: coordinator)
    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print("\(self.dynamicType) \(#function)")
        super.willTransition(to: newCollection, with: coordinator)
    }
}

