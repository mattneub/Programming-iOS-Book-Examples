

import UIKit


class ChildViewController1 : Base {
    
}

class ChildViewController2 : Base {
    
}

class Base : UIViewController {
    override func willMove(toParent parent: UIViewController?) {
        print("\(type(of:self)) \(#function) \(String(describing: parent))")
        super.willMove(toParent:parent)
    }
    override func didMove(toParent parent: UIViewController?) {
        print("\(type(of:self)) \(#function) \(String(describing: parent))")
        super.didMove(toParent:parent)
    }
    override func viewWillAppear(_ animated: Bool) {
        print("\(type(of:self)) \(#function)")
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        print("\(type(of:self)) \(#function)")
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("\(type(of:self)) \(#function)")
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("\(type(of:self)) \(#function)")
        super.viewDidDisappear(animated)
    }
    override func viewWillLayoutSubviews() {
        print("\(type(of:self)) \(#function)")
    }
    override func viewDidLayoutSubviews() {
        print("\(type(of:self)) \(#function)")
    }
    override func updateViewConstraints() {
        print("\(type(of:self)) \(#function)")
        super.updateViewConstraints()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("\(type(of:self)) \(#function)")
        super.viewWillTransition(to: size, with: coordinator)
    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print("\(type(of:self)) \(#function)")
        super.willTransition(to: newCollection, with: coordinator)
    }
}

