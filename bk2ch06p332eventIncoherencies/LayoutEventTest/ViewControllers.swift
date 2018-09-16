

import UIKit

class Base : UIViewController {
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent:parent)
        print("\(self) \(#function) \(String(describing: parent))")
    }
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent:parent)
        print("\(self) \(#function) \(String(describing: parent))")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self) \(#function)")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self) \(#function)")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(self) \(#function)")
    }
    override func viewDidDisappear(_ animated: Bool) {
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
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("\(self) \(#function)")
    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        print("\(self) \(#function)")
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print("\(self) \(#function)")
    }
}

class ViewController1 : Base {
    
}

class ViewController2 : Base {
    
}

