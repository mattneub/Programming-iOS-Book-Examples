
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationController.delegate = self
        print("viewDidLoad")
        print("viewDidLoad reports \(self.view.bounds.size)")
        print("viewDidLoad reports \(self.traitCollection)")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("will appear \(self.view.bounds.size)")
    }
    
    override func viewWillLayoutSubviews() {
        print("willLayout  \(self.view.bounds.size)")
    }
    
    override func viewDidLayoutSubviews() {
        print("didLayout \(self.view.bounds.size)")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("did appear \(self.view.bounds.size)")
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        print("willTransition trait")
        print(newCollection)
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        print("willTransition size")
        print(size)
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        print("trait collection did change")
    }
    

    
}

