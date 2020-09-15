

import UIKit

class MyButton : UIButton {
    // not clear to me that there's any point to this
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let rect = self.bounds.insetBy(dx: -24, dy: -24)
        return rect.contains(point) ? self : nil
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton! // test pointer interaction
    @IBOutlet weak var greenView: UIView! // test hover
    @IBOutlet weak var yellowView: UIView! // test button number
    @IBOutlet weak var redView: UIView! // test scroll
    @IBOutlet weak var blueView: UIView! // test pointer interaction
    @IBOutlet weak var pepView: UIView! // test regions
    
    override var canBecomeFirstResponder: Bool { true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
        let command = UIKeyCommand(title: "Test", action: #selector(doTest), input: "t", modifierFlags: [.command, .shift])
        // this works too, but we are not listed in the Command HUD
        let command2 = UIKeyCommand(input: "t", modifierFlags: [.command, .shift], action: #selector(doTest))
        self.addKeyCommand(command)
        
        self.button.pointerStyleProvider = { button, effect, shape in
            let params = UIPreviewParameters()
            params.shadowPath = UIBezierPath(rect: button.bounds.insetBy(dx: -24, dy: -24))
            let effect = UIPointerEffect.lift(UITargetedPreview(view: button, parameters: params))
            let con = effect.preview.target.container // if we set a shape, we'd need this for coordinate space
            return UIPointerStyle(effect: effect, shape: shape)
        }
        
        self.greenView.addGestureRecognizer(UIHoverGestureRecognizer(target: self, action: #selector(hover)))
        
        let tapper = UITapGestureRecognizer(target: self, action: #selector(tap))
        // only when capturing external input, only secondary button
        tapper.buttonMaskRequired = .button(2)
        tapper.allowedTouchTypes = [UITouch.TouchType.indirectPointer.rawValue as NSNumber]
        self.yellowView.addGestureRecognizer(tapper)
        
        let pangr = UIPanGestureRecognizer(target: self, action: #selector(pan))
        // scroll wheel on external input
        pangr.allowedScrollTypesMask = [.discrete]
        pangr.allowedTouchTypes = [UITouch.TouchType.indirectPointer.rawValue as NSNumber]
        self.redView.addGestureRecognizer(pangr)
        
        let inter = UIPointerInteraction(delegate: self)
        self.blueView.addInteraction(inter)
        
        let inter2 = UIPointerInteraction(delegate: self)
        self.pepView.addInteraction(inter2)
        
    }
    @IBAction func doTestButton(_ sender: Any) {
        print("Test")
    }
    @objc func doTest(_ command: UIKeyCommand) { // optional parameter
        print("Test", command)
    }
    @objc func hover(_ gr: UIGestureRecognizer) {
        switch gr.state {
        case .began: print("began")
        case .changed: print("changed")
        case .ended: print("ended")
        default: break
        }
    }
    @objc func tap(_ gr: UITapGestureRecognizer ) {
        print("tap", gr.modifierFlags)
    }
    @objc func pan(_ gr: UIPanGestureRecognizer) {
        print("scroll")
    }
}

extension ViewController : UIPointerInteractionDelegate {
    func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region: UIPointerRegion) -> UIPointerStyle? {
        if interaction.view == self.blueView {
            let view = interaction.view
            let target = UITargetedPreview(view: view!)
            return UIPointerStyle(effect: UIPointerEffect.lift(target))
        }
        if let tag = region.identifier as? Int {
            if let view = interaction.view?.viewWithTag(tag) {
                let target = UITargetedPreview(view: view)
                // the trick here is centering the shape
                let shape = UIPointerShape.path(UIBezierPath(ovalIn: CGRect(x: -20, y: -10, width: 40, height: 20)))
                return UIPointerStyle(effect: UIPointerEffect.hover(target), shape: shape)
            }
        }
        return nil
    }
    func pointerInteraction(_ inter: UIPointerInteraction, regionFor request: UIPointerRegionRequest, defaultRegion: UIPointerRegion) -> UIPointerRegion? {
        if inter.view == self.blueView { return defaultRegion }
        let loc = request.location
        if let iv = inter.view!.hitTest(loc, with: nil) as? UIImageView {
            let rect = inter.view!.convert(iv.bounds, from: iv)
            let region = UIPointerRegion(rect: rect, identifier: iv.tag)
            return region
        }
        return nil
    }
}

