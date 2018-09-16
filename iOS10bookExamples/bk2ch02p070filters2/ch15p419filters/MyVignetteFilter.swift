
import UIKit

class MyVignetteFilter : CIFilter {
    var inputImage : CIImage?
    var inputPercentage : NSNumber? = 1.0
    
    override var outputImage : CIImage? {
        return self.makeOutputImage()
    }
    
    deinit {
        // just making sure we are not leaking
        print("farewell")
    }
    
    private func makeOutputImage () -> CIImage? {
        guard let inputImage = self.inputImage else {return nil}
        guard let inputPercentage = self.inputPercentage else {return nil}
        
        let extent = inputImage.extent
        
        let grad = CIFilter(name: "CIRadialGradient")!
        let center = CIVector(x: extent.width/2.0, y: extent.height/2.0)
        
        let smallerDimension = min(extent.width, extent.height)
        let largerDimension = max(extent.width, extent.height)
        
        grad.setValue(center, forKey:"inputCenter")
        grad.setValue(smallerDimension/2.0 * CGFloat(inputPercentage), forKey:"inputRadius0")
        grad.setValue(largerDimension/2.0, forKey:"inputRadius1")
        
        let blend = CIFilter(name: "CIBlendWithMask")!
        blend.setValue(inputImage, forKey: "inputImage")
        blend.setValue(grad.outputImage, forKey: "inputMaskImage")
                
        return blend.outputImage
    }
}
