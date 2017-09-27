

import UIKit

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



class MyView : UIView {
    override func didAddSubview(_ subview: UIView) {
        print("did add")
        print(self.gestureRecognizers?.count as Any)
    }
    override func willRemoveSubview(_ subview: UIView) {
        print("will remove")
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var dragView: UIView!
    @IBOutlet weak var dropView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dragger = UIDragInteraction(delegate: self)
        self.dragView.addInteraction(dragger)
        print(dragger.isEnabled) // false on iPhone! that explains a lot, eh?
        dragger.isEnabled = true // for iPhone: presto, we've got drag and drop!
        
        let dropper = UIDropInteraction(delegate: self)
        self.dropView.addInteraction(dropper)
    }
}

extension ViewController : UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        let ip = NSItemProvider(object: UIColor.red)
        let di = UIDragItem(itemProvider: ip)
        di.previewProvider = {
            let v = UIView(frame:CGRect(20,20,20,20))
            v.backgroundColor = .white
            return UIDragPreview(view: v)
        }
        di.previewProvider = nil // didn't like that effect
        print("item provider going in", ip, session)
        return [di]
    }
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        let lab = UILabel()
        lab.text = "RED"
        lab.textAlignment = .center
        lab.textColor = .red
        lab.layer.borderWidth = 1
        lab.layer.cornerRadius = 10
        lab.sizeToFit()
        lab.frame = lab.frame.insetBy(dx: -10, dy: -10)
        let v = interaction.view!
        let ptrLoc = session.location(in: v)
        let targ = UIDragPreviewTarget(container: v, center: ptrLoc)
        let params = UIDragPreviewParameters()
        params.backgroundColor = .white
        return UITargetedDragPreview(view: lab, parameters: params, target: targ)
    }
    func dragInteraction(_ interaction: UIDragInteraction, willAnimateLiftWith animator: UIDragAnimating, session: UIDragSession) {
        if let v = interaction.view {
            animator.addAnimations {
                v.alpha = 0.5
                // proving that the animation is applied before the automatic snapshot
                // v.backgroundColor = .green
                
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
    func dragInteraction(_ interaction: UIDragInteraction, previewForCancelling item: UIDragItem, withDefault p: UITargetedDragPreview) -> UITargetedDragPreview? {
        let v = interaction.view!
        let target = UIDragPreviewTarget(container: v.superview!, center: v.center, transform: CGAffineTransform(scaleX: 0, y: 0))
        // return UITargetedDragPreview(view: p.view, parameters: UIDragPreviewParameters(), target:target)
        return p.retargetedPreview(with: target)
    }
}

extension ViewController : UIDropInteractionDelegate {
    // just playing
    func dropInteraction(_ interaction: UIDropInteraction, previewForDropping item: UIDragItem, withDefault p: UITargetedDragPreview) -> UITargetedDragPreview? {
        print("prev")
        let v = UIView(frame:p.view.frame)
        v.backgroundColor = .red
        let targ = UIDragPreviewTarget(container: interaction.view!.superview!, center: interaction.view!.center, transform:CGAffineTransform(scaleX: 0, y: 0))
        return UITargetedDragPreview(view: v, parameters: UIDragPreviewParameters(), target: targ)
    }
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
        print(interaction.view?.gestureRecognizers?.count as Any)
        var which : Int { return 2 }
        switch which {
        case 1:
            session.loadObjects(ofClass: UIColor.self) { colors in
                if let color = colors[0] as? UIColor {
                    print(color)
                    print("main thread?", Thread.isMainThread) // true
                }
            }
        case 2:
            for item in session.items {
                let ip = item.itemProvider
                print("item provider coming out", ip, session)
                ip.loadObject(ofClass: UIColor.self) { (color, error) in
                    if let color = color as? UIColor {
                        print(color)
                        print("main thread?", Thread.isMainThread) // false
                    }
                }
                
            }
        default: break
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, concludeDrop session: UIDropSession) {
        let finished = session.progress.isFinished
        print("finished?", finished)
    }
}

