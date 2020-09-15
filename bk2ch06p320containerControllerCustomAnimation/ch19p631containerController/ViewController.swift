
import UIKit

class ViewController : UIViewController {
    
    @IBOutlet var panel : UIView!
    var cur : Int = 0
    var swappers = [UIViewController]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // still assuming that this trick will work
        self.swappers += [FirstViewController()]
        self.swappers += [SecondViewController()]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = self.swappers[cur]
        self.addChild(vc) // "will" called for us
        vc.view.frame = self.panel.bounds
        self.panel.addSubview(vc.view) // insert view into interface between "will" and "did"
        // note: when we call add, we must call "did" afterwards
        vc.didMove(toParent: self)
        
        self.constrainInPanel(vc.view) // *
    }
    
    @IBAction func doFlip(_ sender: Any?) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        let fromvc = self.swappers[cur]
        cur = cur == 0 ? 1 : 0
        let tovc = self.swappers[cur]
        tovc.view.frame = self.panel.bounds

        let r = UIGraphicsImageRenderer(size:tovc.view.bounds.size)
        let im = r.image { ctx in
            tovc.view.layer.render(in:ctx.cgContext)
        }

        
        let iv = UIImageView(image:im)
        iv.frame = .zero
        self.panel.addSubview(iv)
        tovc.view.alpha = 0 // hide the real view
        
        // must have both as children before we can transition between them
        self.addChild(tovc) // "will" called for us
        // when we call remove, we must call "will" (with nil) beforehand
        fromvc.willMove(toParent: nil)
        // then perform the transition
        self.transition(
            from:fromvc, to:tovc,
            duration:0.4, // no options:
            animations: {
                iv.frame = tovc.view.frame // animate bounds change
                self.constrainInPanel(tovc.view) // *
        }) { _ in
            tovc.view.alpha = 1
            iv.removeFromSuperview()
            // when we call add, we must call "did" afterwards
            tovc.didMove(toParent: self)
            fromvc.removeFromParent() // "did" called for us
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    func constrainInPanel(_ v:UIView) {
        print("constrain")
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat:"H:|[v]|", metrics:nil, views:["v":v]),
            NSLayoutConstraint.constraints(withVisualFormat:"V:|[v]|", metrics:nil, views:["v":v])
            ].flatMap{$0})
    }
    
}
