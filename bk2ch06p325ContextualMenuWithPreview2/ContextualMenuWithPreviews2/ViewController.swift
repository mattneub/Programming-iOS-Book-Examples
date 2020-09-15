

import UIKit

extension UIView {
    @IBInspectable var name : String? {
        get { return self.layer.name }
        set { self.layer.name = newValue }
    }
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController: UIViewController, UIContextMenuInteractionDelegate {
    @IBOutlet weak var imageBackground: UIView!
    let boys = ["manny", "moe", "jack"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let interaction = UIContextMenuInteraction(delegate: self)
        self.imageBackground.addInteraction(interaction)
    }

    func contextMenuInteraction(_ inter: UIContextMenuInteraction, configurationForMenuAtLocation loc: CGPoint) -> UIContextMenuConfiguration? {
        // return nil // nothing happens at all
        guard let imageView =
            inter.view?.hitTest(loc, with: nil) as? UIImageView else { return nil }
        let boy = boys[imageView.tag - 1]
        let tag = imageView.tag as NSNumber
        let config = UIContextMenuConfiguration(identifier: tag) {
            // return nil
            let pep = Pep(pepBoy: boy)
            pep.preferredContentSize = CGSize(width: 240, height: 300)
            return pep
        } actionProvider: { _ in
//            return nil
            let simpleAction = UIAction(title: "Testing") { _ in }
            return UIMenu(title: "", children: [simpleAction])
            let def = UIDeferredMenuElement { f in
                delay(2) {
                    let action = UIAction(title: "Yoho") { action in
                        // do nothing
                    }
                    let action2 = UIAction(title: "Yoho") { action in
                        // do nothing
                    }

                    f([action, action2])
                }
            }
            
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
            return UIMenu(title: "", children: [favorite, color, def])
        }
        return config
    }

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForHighlightingMenuWithConfiguration config: UIContextMenuConfiguration) -> UITargetedPreview? {
        if let tag = config.identifier as? Int {
            if let imageView = self.imageBackground.viewWithTag(tag) {
                return UITargetedPreview(view: imageView)
            }
        }
        return nil
    }

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        if let vc = animator.previewViewController as? Pep {
            animator.preferredCommitStyle = .pop
            animator.addCompletion {
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true)
            }
        }
    }

}

