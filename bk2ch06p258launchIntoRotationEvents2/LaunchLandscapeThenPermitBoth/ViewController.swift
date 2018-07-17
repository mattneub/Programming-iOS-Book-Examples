
import UIKit

extension UIUserInterfaceSizeClass : CustomStringConvertible {
    public var description : String {
        if self == .compact {return "compact"}
        if self == .regular {return "regular"}
        return "unknown"
    }
}

extension UITraitCollection {
    open override var description : String {
        return "\(self.horizontalSizeClass) \(self.verticalSizeClass)"
    }
    open override var debugDescription : String {
        return "\(self.horizontalSizeClass) \(self.verticalSizeClass)"
    }
}


class ViewController: UIViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationController.delegate = self
        print("viewDidLoad")
        print("viewDidLoad reports \(self.view.bounds.size)")
        print("viewDidLoad reports \(self.traitCollection)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("will appear \(self.view.bounds.size)")
    }
    
    override func viewWillLayoutSubviews() {
        print("willLayout  \(self.view.bounds.size)")
    }
    
    override func viewDidLayoutSubviews() {
        print("didLayout \(self.view.bounds.size)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("did appear \(self.view.bounds.size)")
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print("willTransition trait", newCollection)
        super.willTransition(to: newCollection, with: coordinator)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("willTransition size", size)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print("trait collection did change")
    }
    
    @IBAction func unwind(_ sender:UIStoryboardSegue) {}
    
}

