
import UIKit

class ViewController : UIViewController {
    
    @IBOutlet var iv : UIImageView!
    
    let which = 1

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mars = UIImage(named:"Mars")!
        var marsTiled = UIImage()
        
        // this line crashes the compiler for some reason
        // let test = UIEdgeInsets.zero
        
        switch which {
        case 1:
            marsTiled = mars.resizableImage(withCapInsets: .zero, resizingMode: .tile)
        case 2:
            marsTiled = mars.resizableImage(withCapInsets:
                UIEdgeInsets(
                    top: mars.size.height / 4.0,
                    left: mars.size.width / 4.0,
                    bottom: mars.size.height / 4.0,
                    right: mars.size.width / 4.0
                ), resizingMode: .tile)
        case 3:
            marsTiled = mars.resizableImage(withCapInsets:
                UIEdgeInsets(
                    top: mars.size.height / 4.0,
                    left: mars.size.width / 4.0,
                    bottom: mars.size.height / 4.0,
                    right: mars.size.width / 4.0
                ), resizingMode: .stretch)
        case 4:
            marsTiled = mars.resizableImage(withCapInsets:
                UIEdgeInsets(
                    top: mars.size.height / 2.0 - 1,
                    left: mars.size.width / 2.0 - 1,
                    bottom: mars.size.height / 2.0 - 1,
                    right: mars.size.width / 2.0 - 1
                ), resizingMode: .stretch)
        default: break
        }
        
        self.iv.image = marsTiled
    }
    
}
