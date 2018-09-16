
import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController : UIViewController {
    @IBOutlet var iv : UIImageView!
    let context = CIContext()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let moi = UIImage(named:"Moi")!
        let moici = CIImage(image:moi)!
        let moiextent = moici.extent
        
        let center = CIVector(x: moiextent.width/2.0, y: moiextent.height/2.0)
        
        let smallerDimension = min(moiextent.width, moiextent.height)
        let largerDimension = max(moiextent.width, moiextent.height)
        
        // first filter
        let grad = CIFilter(name: "CIRadialGradient")!
        grad.setValue(center, forKey:"inputCenter")
        grad.setValue(smallerDimension/2.0 * 0.85, forKey:"inputRadius0")
        grad.setValue(largerDimension/2.0, forKey:"inputRadius1")
        let gradimage = grad.outputImage!

        // second filter
        let blendimage = moici.applyingFilter(
            "CIBlendWithMask", parameters: [
                "inputMaskImage":gradimage
            ])
        
        // two ways to obtain final bitmap; third way, claimed to work, does not
        
        var which : Int { return 1 }
        
        switch which {
        case 1:
            let moicg = self.context.createCGImage(blendimage, from: moiextent)!
            self.iv.image = UIImage(cgImage: moicg)
        case 2:
            let r = UIGraphicsImageRenderer(size:moiextent.size)
            self.iv.image = r.image {
                _ in
                UIImage(ciImage: blendimage).draw(in:moiextent)
            }
        case 3:
            self.iv.image = UIImage(ciImage: blendimage, scale: 1, orientation: .up) // nope
            delay(0.1) {
                self.iv.setNeedsDisplay() // nope
                self.iv.layer.displayIfNeeded() // nope
            }
        default: break
        }
        
    }
    
    
}
