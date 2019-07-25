
import UIKit
import CoreImage.CIFilterBuiltins

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
        
        let center = CIVector(x: moiextent.midX, y: moiextent.midY)
        // let center2 = CGPoint(x: moiextent.midX, y: moiextent.midY)
        
        let smallerDimension = min(moiextent.width, moiextent.height)
        let largerDimension = max(moiextent.width, moiextent.height)
        
        // first filter
        let grad = CIFilter.radialGradient()
        grad.setValue(center, forKey: "inputCenter") // setting .center didn't work
        // grad.center = center2
        grad.radius0 = Float(smallerDimension)/2.0 * 0.7
        grad.radius1 = Float(largerDimension)/2.0
        let gradimage = grad.outputImage!


        // second filter
        let blend = CIFilter.blendWithMask()
        blend.inputImage = moici
        blend.maskImage = gradimage
        let blendimage = blend.outputImage!

        // ways to obtain final bitmap
        
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
            // aha: works only on device
            // now works in simulator too because we've got metal
            self.iv.image = UIImage(ciImage: blendimage, scale: 1, orientation: .up)
        default: break
        }
        
        // you can also render thru a metal view, shown in a different example
    }
    
    
}
