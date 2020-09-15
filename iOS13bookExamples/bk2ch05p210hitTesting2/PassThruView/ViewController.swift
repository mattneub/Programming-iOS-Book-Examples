

import UIKit

class MyView: UIView {
    weak var passthruView : UIView?
    override func hitTest(_ point: CGPoint, with e: UIEvent?) -> UIView? {
        if let pv = self.passthruView {
            let pt = pv.convert(point, from: self)
            if pv.point(inside: pt, with: e) {
                return nil
            }
        }
        return super.hitTest(point, with: e)
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var b: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = MyView()
        v.passthruView = self.b
        self.view.addSubview(v)
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: self.view.topAnchor),
            v.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        
    }



}

