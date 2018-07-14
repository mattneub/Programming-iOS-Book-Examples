

import UIKit
import MetalKit

// metal view subclass that does nothing but render a CIImage once
// this is really all a kind of boilerplate

class MyMTKView : MTKView {
    var context : CIContext?
    var queue: MTLCommandQueue!
    var image: CIImage! { // you set it, we draw it
        didSet {
            self.setNeedsDisplay()
        }
    }

    required init(coder: NSCoder) {
        super.init(coder:coder)
        self.isOpaque = false // otherwise background is black
        // must have a "device"
        guard let device = MTLCreateSystemDefaultDevice() else {
            print("darn")
            return
        }
        self.device = device
        // mode: draw on demand
        self.isPaused = true
        self.enableSetNeedsDisplay = true
        // other stuff
        self.context = CIContext(mtlDevice: device)
        self.queue = device.makeCommandQueue()
    }
    
    override func draw() {
        print("draw!") // called once
        print(self.drawableSize)

        
        // should apply transforms here
        // resolution is not taken into account, so we scale up
        // y coordinate is flipped so we move up from bottom
        var transform = CGAffineTransform(scaleX: 2, y: 2)
        transform = transform.translatedBy(x: 0, y: 100)
        let image2 = self.image.transformed(by: transform)
        
        // minimal dance required in order to draw: render, present, commit
        let buffer = self.queue.makeCommandBuffer()!
        self.context!.render(image2,
                             to: self.currentDrawable!.texture,
                             commandBuffer: buffer,
                             bounds: CGRect(origin: .zero, size: self.drawableSize),
                             colorSpace: CGColorSpaceCreateDeviceRGB())
        buffer.present(self.currentDrawable!)
        buffer.commit()

    }
}

class ViewController: UIViewController {
    @IBOutlet weak var metalView: MyMTKView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let moi = UIImage(named:"Moi")!
        let moici = CIImage(image:moi)!
        let moiextent = moici.extent
        
        let center = CIVector(x: moiextent.width/2.0, y: moiextent.height/2.0)
        
        let smallerDimension = min(moiextent.width, moiextent.height)
        let largerDimension = max(moiextent.width, moiextent.height)
        
        // first filter
        let grad = CIFilter(name: "CIRadialGradient")!
        grad.setValue(center, forKey:"inputCenter")
        grad.setValue(smallerDimension/2.0 * 0.85, forKey:"inputRadius0")
        grad.setValue(largerDimension/2.0, forKey:"inputRadius1")
        let gradimage = grad.outputImage!
        
        // second filter
        let blendimage = moici.applyingFilter(
            "CIBlendWithMask", parameters: [
                "inputMaskImage":gradimage
            ])

        self.metalView.image = blendimage
    }
}


