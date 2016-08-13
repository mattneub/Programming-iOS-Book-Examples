

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerForPreviewing(with: self, sourceView: self.stackView) // *

    }

    @IBOutlet var stackView : UIStackView!
    @IBOutlet var container : UIView!
    @IBAction func doShowBoy(_ sender : UIButton) {
        let title = sender.title(for: .normal)!
        let pep = Pep(pepBoy: title)
        self.transitionContainerTo(pep)
    }
    func transitionContainerTo(_ pep:Pep) {
        let oldvc = self.childViewControllers[0]
        pep.view.frame = self.container.bounds
        self.addChildViewController(pep)
        oldvc.willMove(toParentViewController: nil)
        self.transition(
            from: oldvc, to: pep,
            duration: 0.2, options: .transitionCrossDissolve,
            animations: nil) { _ in
                pep.didMove(toParentViewController: self)
                oldvc.removeFromParentViewController()
        }
    }
}

extension ViewController : UIViewControllerPreviewingDelegate {
    func previewingContext(_ ctx: UIViewControllerPreviewing, viewControllerForLocation loc: CGPoint) -> UIViewController? {
        // loc is in source view's coordinate system
        let sv = ctx.sourceView
        guard let button = sv.hitTest(loc, with: nil) as? UIButton else {return nil}
        let title = button.title(for: .normal)!
        let pep = Pep(pepBoy: title)
        ctx.sourceRect = button.frame
        print("returning", pep)
        return pep
    }
    func previewingContext(_ ctx: UIViewControllerPreviewing, commit vc: UIViewController) {
        if let pep = vc as? Pep {
            self.transitionContainerTo(pep)
        }
    }
}

// if there are also menu items, they are in the previewed vc (Pep)


