

import UIKit

class ViewController: UIViewController, UIContextMenuInteractionDelegate {

    @IBOutlet var buttonSuperview : UIView!
    @IBOutlet var container : UIView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonSuperview.addInteraction(UIContextMenuInteraction(delegate: self))
    }
    
    func contextMenuInteraction(_ inter: UIContextMenuInteraction, configurationForMenuAtLocation loc: CGPoint) -> UIContextMenuConfiguration? {
        guard let button = inter.view?.hitTest(loc, with: nil) as? UIButton else {return nil}
        let boy = button.currentTitle!
        let favKey = "favoritePepBoy"
        let fav = UserDefaults.standard.string(forKey:favKey)
        let star = boy == fav ? "star.fill" : "star"
        let im = UIImage(systemName: star)
        let favorite = UIAction(title: "Favorite", image: im) { _ in
            print(boy, "is now your favorite")
            UserDefaults.standard.set(boy, forKey:favKey)
        }
        let red = UIAction(title: "Red") {action in
            print ("coloring", boy, action.title.lowercased())
        }
        let green = UIAction(title: "Green") {action in
            print ("coloring", boy, action.title.lowercased())
        }
        let blue = UIAction(title: "Blue") {action in
            print ("coloring", boy, action.title.lowercased())
        }
        let color = UIMenu(title: "Colorize", children: [red,green,blue])
        let config = UIContextMenuConfiguration(identifier: button.tag as NSNumber, previewProvider: {
            // return nil
            let pep = Pep(pepBoy: boy)
            pep.preferredContentSize = CGSize(width: 240, height: 300)
            return pep
        })
        { _  in
            // return nil
            return UIMenu(title: "", children: [favorite, color])
        }
        return config
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForHighlightingMenuWithConfiguration config: UIContextMenuConfiguration) -> UITargetedPreview? {
        if let tag = config.identifier as? Int {
            if let button = self.buttonSuperview.viewWithTag(tag) {
                return UITargetedPreview(view: button)
            }
        }
        return nil
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        print("preview action")
        if let vc = animator.previewViewController as? Pep {
            animator.preferredCommitStyle = .pop
            animator.addCompletion {
                self.transitionContainerTo(vc)
                // self.present(vc, animated: true)
            }
        }
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

