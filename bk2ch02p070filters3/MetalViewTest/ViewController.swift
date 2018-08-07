

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
        
        // self.backgroundColor = .black
        
    }
    
    override func draw() {
        print("draw!") // called once

        // three problems
        // first, drawableSize is double-scaled for double-resolution screen...
        // ...so our image needs to be doubled in size
        // second, we are drawn into the lower _left_ of the `bounds` we render into
        // third, if our `bounds` isn't big enough it cuts us off, regardless of origin
        
        // so I'm using _transforms_ to position the image at the top center
        
        let scale = self.layer.contentsScale
        var im2 = self.image.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        let imsz = im2.extent.size
        let x = self.drawableSize.width/2 - imsz.width/2
        im2 = im2.transformed(by: CGAffineTransform(translationX: x, y: 0))
        
        // minimal dance required in order to draw: render, present, commit
        let buffer = self.queue.makeCommandBuffer()!
        self.context!.render(im2,
                             to: self.currentDrawable!.texture,
                             commandBuffer: buffer,
                             bounds: CGRect(origin:.zero, size:CGSize(width:self.drawableSize.width,height:imsz.height)),
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
        grad.setValue(smallerDimension/2.0 * 0.7, forKey:"inputRadius0")
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


