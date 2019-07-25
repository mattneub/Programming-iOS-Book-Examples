
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
        
        let center = CIVector(x: extent.midX, y: extent.midY)
        // let center2 = CGPoint(x: extent.midX, y: extent.midY)
        
        let smallerDimension = min(extent.width, extent.height)
        let largerDimension = max(extent.width, extent.height)
        
        // first filter
        let grad = CIFilter.radialGradient()
        grad.setValue(center, forKey: "inputCenter") // setting .center didn't work
        // grad.center = center2
        grad.radius0 = Float(smallerDimension)/2.0 * inputPercentage.floatValue
        grad.radius1 = Float(largerDimension)/2.0
        let gradimage = grad.outputImage!


        // second filter
        let blend = CIFilter.blendWithMask()
        blend.inputImage = self.inputImage
        blend.maskImage = gradimage

        return blend.outputImage
    }
}
