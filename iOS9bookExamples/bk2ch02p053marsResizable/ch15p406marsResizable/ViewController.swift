
import UIKit

class ViewController : UIViewController {
    
    @IBOutlet var iv : UIImageView!
    
    let which = 1

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mars = UIImage(named:"Mars")!
        var marsTiled = UIImage()
        
        switch which {
        case 1:
            marsTiled = mars.resizableImageWithCapInsets(UIEdgeInsetsZero, resizingMode: .Tile)
        case 2:
            marsTiled = mars.resizableImageWithCapInsets(
                UIEdgeInsetsMake(
                    mars.size.height / 4.0,
                    mars.size.width / 4.0,
                    mars.size.height / 4.0,
                    mars.size.width / 4.0
                ), resizingMode: .Tile)
        case 3:
            marsTiled = mars.resizableImageWithCapInsets(
                UIEdgeInsetsMake(
                    mars.size.height / 4.0,
                    mars.size.width / 4.0,
                    mars.size.height / 4.0,
                    mars.size.width / 4.0
                ), resizingMode: .Stretch)
        case 4:
            marsTiled = mars.resizableImageWithCapInsets(
                UIEdgeInsetsMake(
                    mars.size.height / 2.0 - 1,
                    mars.size.width / 2.0 - 1,
                    mars.size.height / 2.0 - 1,
                    mars.size.width / 2.0 - 1
                ), resizingMode: .Stretch)
        default: break
        }
        
        self.iv.image = marsTiled
    }
    
}