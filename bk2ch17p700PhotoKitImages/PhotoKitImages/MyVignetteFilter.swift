
import UIKit

// work around odd behavior (bug?) where CIColor(color:UIColor.whiteColor()) gives transparent, not white
extension CIColor {
    convenience init(uicolor:UIColor) {
        var red : CGFloat = 0, green : CGFloat = 0, blue : CGFloat = 0, alpha : CGFloat = 0
        uicolor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.init(red: red, green: green, blue: blue, alpha:alpha)
    }
}

class MyVignetteFilter : CIFilter {
    var inputImage : CIImage!
    var inputPercentage : NSNumber! = NSNumber(double: 1.0)
    override var outputImage : CIImage! {
        get {
            return self.makeOutputImage()
        }
    }
    
    
    func makeOutputImage () -> CIImage {
        let moiextent = self.inputImage.extent()
        
        let grad = CIFilter(name: "CIRadialGradient")
        let center = CIVector(x: moiextent.width/2.0, y: moiextent.height/2.0)
        
        let smallerDimension = min(moiextent.width, moiextent.height)
        let largerDimension = max(moiextent.width, moiextent.height)
        
        grad.setValue(center, forKey:"inputCenter")
        grad.setValue(smallerDimension/2.0 * CGFloat(self.inputPercentage), forKey:"inputRadius0")
        grad.setValue(largerDimension/2.0, forKey:"inputRadius1")
        grad.setValue(CIColor(color: UIColor.whiteColor()), forKey:"inputColor0")
        grad.setValue(CIColor(color: UIColor.clearColor()), forKey:"inputColor1")
        let gradimage = grad.outputImage
        
        let blend = CIFilter(name: "CIBlendWithAlphaMask")
        blend.setValue(self.inputImage, forKey: "inputImage")
        let background = CIImage(color: CIColor(uicolor: UIColor.whiteColor()))
        let background2 = background.imageByCroppingToRect(self.inputImage.extent())
        blend.setValue(background2, forKey:"inputBackgroundImage")
        blend.setValue(gradimage, forKey: "inputMaskImage")
        
        return blend.outputImage
    }
}
