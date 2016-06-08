

import UIKit

class ViewController: UIViewController {
    @IBOutlet var v: MyView!
    
    // MyView presents a facade where its "swing" property is view-animatable
    
    @IBAction func doButton(_ sender: AnyObject) {
        UIView.animate(withDuration:1) {
            self.v.swing = !self.v.swing // "animatable" Bool property
        }
    }
    

}

class MyView : UIView {
    var swing : Bool = false {
    didSet {
        var p = self.center
        p.x = self.swing ? p.x + 100 : p.x - 100
        // this is the trick: perform actual view animation with zero duration
        // zero duration means we inherit the surrounding duration
        UIView.animate(withDuration:0) {
            self.center = p
        }
    }
    }
}

