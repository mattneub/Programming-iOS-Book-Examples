
import UIKit

// there's a bug when an image view's image is set in IB and comes from the app bundle:
// the triple-resolution version is used on double-resolution devices
// otherwise, triple-resolution is confined to the triple-resolution device

// so the asset catalog version works,
// and the init(named:) versions work

// aha, further testing suggests that the bug is in `pathForResource`

// bug fixed in Xcode 6.1!

class ViewController: UIViewController {
    @IBOutlet weak var iv3: UIImageView!
    @IBOutlet weak var iv4: UIImageView!
    @IBOutlet weak var iv5: UIImageView!
    @IBOutlet weak var iv6: UIImageView!

    @IBOutlet weak var iv: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        println(self.iv.image!.scale)
        
        self.iv3.image = UIImage(named:"one")
        self.iv4.image = UIImage(named:"uno")
        
        if let s = NSBundle.mainBundle().pathForResource("one", ofType: "png") {
            self.iv5.image = UIImage(contentsOfFile: s)
        }
        if let s2 = NSBundle.mainBundle().pathForResource("uno", ofType: "png") {
            self.iv6.image = UIImage(contentsOfFile: s2)
        } else {
            println("looking for smiley")
            self.iv6.image = UIImage(named:"smiley")
        }

    }



}

