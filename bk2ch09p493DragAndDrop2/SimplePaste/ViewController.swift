

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var dragView: UIView!
    @IBOutlet weak var dropView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dragger = UIDragInteraction(delegate: self)
        self.dragView.addInteraction(dragger)
        
        let dropper = UIDropInteraction(delegate: self)
        self.dropView.addInteraction(dropper)
    }
}

extension ViewController : UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        let ip = NSItemProvider(object: UIColor.red)
        let di = UIDragItem(itemProvider: ip)
        return [di]
    }
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        let lab = UILabel()
        lab.text = "RED"
        lab.textAlignment = .center
        lab.textColor = .red
        lab.layer.borderWidth = 1
        lab.frame = CGRect(origin:.zero, size:lab.sizeThatFits(.zero)).insetBy(dx: -10, dy: -10)
        let targ = UIDragPreviewTarget(container: interaction.view!, center: session.location(in: interaction.view!))
        let params = UIDragPreviewParameters()
        params.backgroundColor = .white
        return UITargetedDragPreview(view: lab, parameters: params, target: targ)
    }
    func dragInteraction(_ interaction: UIDragInteraction, willAnimateLiftWith animator: UIDragAnimating, session: UIDragSession) {
        if let v = interaction.view {
            animator.addAnimations {
                v.alpha = 0.5
            }
//            animator.addCompletion { position in
//                print(position.rawValue)
//                v.alpha = 1
//            }
        }
    }
    func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, willEndWith operation: UIDropOperation) {
        if let v = interaction.view {
            UIView.animate(withDuration:0.3) {
                v.alpha = 1
            }
        }
    }
}

extension ViewController : UIDropInteractionDelegate {
    // front door
    func dropInteractionNOT(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIColor.self)
    }
    // hallway
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let op : UIDropOperation = session.canLoadObjects(ofClass: UIColor.self) ? .copy : .cancel
        return UIDropProposal(operation:op)
    }
    // living room
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        var which : Int { return 2 }
        switch which {
        case 1:
            session.loadObjects(ofClass: UIColor.self) { colors in
                if let color = colors[0] as? UIColor {
                    print(color)
                    print(Thread.isMainThread) // true
                }
            }
        case 2:
            for item in session.items {
                let ip = item.itemProvider
                ip.loadObject(ofClass: UIColor.self) { (color, error) in
                    if let color = color as? UIColor {
                        print(color)
                        print(Thread.isMainThread) // false
                    }
                }
                
            }
        default: break
        }
    }
}

