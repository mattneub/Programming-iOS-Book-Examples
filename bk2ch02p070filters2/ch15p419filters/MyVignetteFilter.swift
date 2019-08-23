
import UIKit
import CoreImage.CIFilterBuiltins

class MyVignetteFilter : CIFilter {
    @objc var inputImage : CIImage?
    @objc var inputPercentage : NSNumber? = 1.0
    
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
        
        let center = CGPoint(x: extent.midX, y: extent.midY)
        
        let smaller = min(extent.width, extent.height)
        let larger = max(extent.width, extent.height)
        
        // first filter
        let grad = CIFilter.radialGradient()
        grad.center = center
        grad.radius0 = Float(smaller)/2.0 * inputPercentage.floatValue
        grad.radius1 = Float(larger)/2.0
        let gradimage = grad.outputImage!

        // second filter
        let blend = CIFilter.blendWithMask()
        blend.inputImage = self.inputImage
        blend.maskImage = gradimage

        return blend.outputImage
    }
}
