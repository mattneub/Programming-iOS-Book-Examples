
import UIKit

class MyVignetteFilter : CIFilter {
    var inputImage : CIImage!
    var inputPercentage = NSNumber(double:1.0)
    
    override var outputImage : CIImage! {
        get {
            return self.makeOutputImage()
        }
    }
    
    deinit {
        // just making sure we are not leaking
        println("farewell")
    }
    
    private func makeOutputImage () -> CIImage {
        let moiextent = self.inputImage.extent()
        
        let grad = CIFilter(name: "CIRadialGradient")
        let center = CIVector(x: moiextent.width/2.0, y: moiextent.height/2.0)
        
        let smallerDimension = min(moiextent.width, moiextent.height)
        let largerDimension = max(moiextent.width, moiextent.height)
        
        grad.setValue(center, forKey:"inputCenter")
        grad.setValue(smallerDimension/2.0 * CGFloat(self.inputPercentage.doubleValue), forKey:"inputRadius0")
        grad.setValue(largerDimension/2.0, forKey:"inputRadius1")
        let gradimage = grad.outputImage
        
        let blend = CIFilter(name: "CIBlendWithMask")
        blend.setValue(self.inputImage, forKey: "inputImage")
        blend.setValue(gradimage, forKey: "inputMaskImage")
                
        return blend.outputImage
    }
}
