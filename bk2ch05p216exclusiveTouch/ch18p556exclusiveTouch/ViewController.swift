
import UIKit

class ViewController : UIViewController {
    
    @IBOutlet weak var sw: UISwitch!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func pinch(_ sender: Any?) {
        print("pinch")
    }
    
    @IBAction func switched(_ sender: Any) {
        let sw = sender as! UISwitch
        for v in self.view.subviews {
            if v is MyView || v is UIButton {
                v.isExclusiveTouch = sw.isOn
            }
        }
    }
    
    func ignoreMe() {
        self.sw.setOn(true, animated: true)
        self.sw.sendActions(for:.valueChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let r = UIGraphicsImageRenderer(size:CGSize(width:20, height:20))
        let im = r.image { _ in
            UIColor.red.setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 0, width: 20, height: 20)).fill()
        }
        self.sw.onImage = im // just proving that this still does nothing
        // also demonstrates a workaround for the off color:
        // there's a switch-shaped image behind the UISwitch!
        
        self.sw.onTintColor = .red
    }
    
    func putColor(_ color: UIColor, behindSwitch sw: UISwitch) {
        guard sw.superview != nil else {return}
        let onswitch = UISwitch()
        onswitch.isOn = true
        let r = UIGraphicsImageRenderer(bounds:sw.bounds)
        let im = r.image { ctx in
            onswitch.layer.render(in: ctx.cgContext)
            }.withRenderingMode(.alwaysTemplate)
        let iv = UIImageView(image:im)
        iv.tintColor = color
        sw.superview!.insertSubview(iv, belowSubview: sw)
        iv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iv.topAnchor.constraint(equalTo: sw.topAnchor),
            iv.bottomAnchor.constraint(equalTo: sw.bottomAnchor),
            iv.leadingAnchor.constraint(equalTo: sw.leadingAnchor),
            iv.trailingAnchor.constraint(equalTo: sw.trailingAnchor),
            ])
    }

    var didLayout = false
    override func viewDidLayoutSubviews() {
        if !didLayout {
            didLayout = true
            self.putColor(.yellow, behindSwitch:self.sw)
        }
    }
}

class MyView : UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with e: UIEvent?) {
        print(self)
    }
    
}
