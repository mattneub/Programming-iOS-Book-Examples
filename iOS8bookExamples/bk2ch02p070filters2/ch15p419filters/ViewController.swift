
import UIKit

class ViewController : UIViewController {
    @IBOutlet var iv : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vig = MyVignetteFilter()
        let moici = CIImage(image: UIImage(named:"Moi"))
        vig.setValue(moici, forKey: "inputImage")
        vig.setValue(NSNumber(double:0.7), forKey: "inputPercentage")
        let outim = vig.outputImage
        
        let outimcg = CIContext(options: nil).createCGImage(outim, fromRect: outim.extent())
        self.iv.image = UIImage(CGImage: outimcg)
    }
    
    
}