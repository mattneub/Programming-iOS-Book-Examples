
import UIKit

// there's a bug when an image view's image is set in IB and comes from the app bundle:
// the triple-resolution version is used on double-resolution devices
// otherwise, triple-resolution is confined to the triple-resolution device

// so the asset catalog version works,
// and the init(named:) versions work

class ViewController: UIViewController {
    @IBOutlet weak var iv3: UIImageView!
    @IBOutlet weak var iv4: UIImageView!

    @IBOutlet weak var iv: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        println(self.iv.image!.scale)
        
        self.iv3.image = UIImage(named:"one")
        self.iv4.image = UIImage(named:"uno")
    }



}

