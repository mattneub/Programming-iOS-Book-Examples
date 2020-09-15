
import UIKit
import CoreImage.CIFilterBuiltins

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}
extension CGRect {
    var center : CGPoint {
        return CGPoint(self.midX, self.midY)
    }
}



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
                
        let smaller = min(extent.width, extent.height)
        let larger = max(extent.width, extent.height)
        
        // first filter
        let grad = CIFilter.radialGradient()
        grad.center = extent.center
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
