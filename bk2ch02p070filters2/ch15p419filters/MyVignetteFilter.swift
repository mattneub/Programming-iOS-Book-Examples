
import UIKit

class MyVignetteFilter : CIFilter {
    // rather elaborate dance, in Swift, to slot needed properties into position
    private var realInputImage : CIImage?
    var inputImage : CIImage {
    get {
        return self.realInputImage!
    }
    set (im) {
        self.realInputImage = im
    }
    }
    private var realInputPercentage : NSNumber = NSNumber(double: 1.0)
    var inputPercentage : NSNumber {
        get {
            return self.realInputPercentage
        }
        set (val) {
            self.realInputPercentage = val
        }
    }

    override var outputImage : CIImage! {
    get {
        return self.makeOutputImage()
    }
    }

    deinit {
        // just making sure we are not leaking
        println("farewell")
    }
    
    func makeOutputImage () -> CIImage {
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
