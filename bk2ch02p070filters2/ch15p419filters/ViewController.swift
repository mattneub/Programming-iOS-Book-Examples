
import UIKit

class ViewController : UIViewController {
    @IBOutlet var iv : UIImageView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vig = MyVignetteFilter()
        let moici = CIImage(CGImage: UIImage(named:"Moi").CGImage)
        vig.setValue(moici, forKey: "inputImage")
        let outim = vig.outputImage
        
        let outimcg = CIContext(options: nil).createCGImage(outim, fromRect: outim.extent())
        self.iv.image = UIImage(CGImage: outimcg)
    }
    
    
}