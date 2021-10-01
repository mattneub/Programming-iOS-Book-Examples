
import UIKit
import Coolness // package

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let coolness = Coolness()
        print(coolness.text)
        coolness.test()
        
        // but what if _we_ want to access a package's bundle resource? not so easy
        // probably not supposed to do this!
        if let url = Bundle.main.resourceURL?.appendingPathComponent("Coolness_Coolness.bundle") {
            if let bundle = Bundle(url: url) {
                // asset catalog
                let manny = UIImage(named: "manny", in: bundle, compatibleWith: nil)
                print(manny as Any)
                let moe = UIImage(named: "moe", in: bundle, compatibleWith: nil)
                print(moe as Any)
                // at base of package pseudo-target
                let jack = UIImage(named: "jack.jpg", in: bundle, compatibleWith: nil)
                print(jack as Any)
            }
        }
    }


}

