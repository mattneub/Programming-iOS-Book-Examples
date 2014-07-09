
import UIKit

class MyVignetteFilter : CIFilter {
    // rather elaborate dance, in Swift, to slot needed properties into position
    var realInputImage : CIImage?
    var inputImage : CIImage {
    get {
        return self.realInputImage!
    }
    set (im) {
        self.realInputImage = im
    }
    }
    override var outputImage : CIImage! {
    get {
        return self.makeOutputImage()
    }
    }
    init() {
        super.init()
    }
    deinit {
        // just making sure we are not leaking
        println("farewell")
    }
    
    func makeOutputImage () -> CIImage {
        let moiextent = self.inputImage.extent()
        
        let grad = CIFilter(name: "CIRadialGradient")
        let center = CIVector(x: moiextent.width/2.0, y: moiextent.height/2.0)
        
        grad.setValue(center, forKey:"inputCenter")
        grad.setValue(85, forKey:"inputRadius0")
        grad.setValue(100, forKey:"inputRadius1")
        let gradimage = grad.outputImage
        
        let blend = CIFilter(name: "CIBlendWithMask")
        blend.setValue(self.inputImage, forKey: "inputImage")
        blend.setValue(gradimage, forKey: "inputMaskImage")
        
        return blend.outputImage
    }
}
