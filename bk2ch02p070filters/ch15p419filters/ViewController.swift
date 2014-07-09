
import UIKit

class ViewController : UIViewController {
    @IBOutlet var iv : UIImageView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let moi = UIImage(named:"Moi")
        let moici = CIImage(CGImage: moi.CGImage)
        let moiextent = moici.extent()
        
        let grad = CIFilter(name: "CIRadialGradient")
        let center = CIVector(x: moiextent.width/2.0, y: moiextent.height/2.0)
        
        grad.setValue(center, forKey:"inputCenter")
        grad.setValue(85, forKey:"inputRadius0")
        grad.setValue(100, forKey:"inputRadius1")
        let gradimage = grad.outputImage
        
        let blend = CIFilter(name: "CIBlendWithMask")
        blend.setValue(moici, forKey: "inputImage")
        blend.setValue(gradimage, forKey: "inputMaskImage")
        
        // two ways to obtain final bitmap
        
        let which = 1
        switch which {
        case 1:
            let moicg = CIContext(options: nil).createCGImage(blend.outputImage, fromRect: moiextent)
            self.iv.image = UIImage(CGImage: moicg)
        case 2:
            UIGraphicsBeginImageContextWithOptions(moiextent.size, false, 0)
            UIImage(CIImage: blend.outputImage).drawInRect(moiextent)
            let im = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.iv.image = im
        default: break
        }
        
    }
    
    
}
