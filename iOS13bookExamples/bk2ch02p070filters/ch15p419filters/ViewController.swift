
import UIKit
import CoreImage.CIFilterBuiltins

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

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




class ViewController : UIViewController {
    @IBOutlet var iv : UIImageView!
    let context = CIContext()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let moi = UIImage(named:"Moi")!
        let moici = CIImage(image:moi)!
        let moiextent = moici.extent
                
        let smaller = min(moiextent.width, moiextent.height)
        let larger = max(moiextent.width, moiextent.height)
        
        // first filter
        let grad = CIFilter.radialGradient()
        grad.center = moiextent.center
        grad.radius0 = Float(smaller)/2.0 * 0.7
        grad.radius1 = Float(larger)/2.0
        let gradimage = grad.outputImage!


        // second filter
        let blend = CIFilter.blendWithMask()
        blend.inputImage = moici
        blend.maskImage = gradimage
        let blendimage = blend.outputImage!

        // ways to obtain final bitmap
        
        var which : Int { return 2 }
        
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
