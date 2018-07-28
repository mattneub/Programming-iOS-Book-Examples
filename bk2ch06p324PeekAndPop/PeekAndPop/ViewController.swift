

import UIKit

class ViewController: UIViewController {

    @IBOutlet var buttonSuperview : UIView!
    @IBOutlet var container : UIView!
    
    // note that a stack view does not do well as the registered view
    // so I've put the stack view inside a container view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerForPreviewing(with: self, sourceView: self.buttonSuperview) // *
    }

    @IBAction func doShowBoy(_ sender : UIButton) {
        let title = sender.title(for: .normal)!
        let pep = Pep(pepBoy: title)
        self.transitionContainerTo(pep)
    }
    func transitionContainerTo(_ pep:Pep) {
        let oldvc = self.children[0]
        pep.view.frame = self.container.bounds
        self.addChild(pep)
        oldvc.willMove(toParent: nil)
        self.transition(
            from: oldvc, to: pep,
            duration: 0.2, options: .transitionCrossDissolve,
            animations: nil) { _ in
                pep.didMove(toParent: self)
                oldvc.removeFromParent()
        }
    }
}

// actual press doesn't have to be on something that responds to a tap gesture, just on a touchable area so that the original touch can be hit-tested to some view

extension ViewController : UIViewControllerPreviewingDelegate {
    func previewingContext(_ ctx: UIViewControllerPreviewing, viewControllerForLocation loc: CGPoint) -> UIViewController? {
        // loc is in source view's coordinate system
        let sv = ctx.sourceView
        guard let button = sv.hitTest(loc, with: nil) as? UIButton else {return nil}
        let title = button.title(for: .normal)!
        let pep = Pep(pepBoy: title)
        ctx.sourceRect = button.convert(button.bounds, to:sv)
        print("previewing context returning", pep)
        return pep
    }
    func previewingContext(_ ctx: UIViewControllerPreviewing, commit vc: UIViewController) {
        if let pep = vc as? Pep {
            print("committing", pep)
            self.transitionContainerTo(pep)
        }
    }
}

// if there are also menu items, they are in the previewed vc (Pep)


