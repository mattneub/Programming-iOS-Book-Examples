

import UIKit
import Photos
import MobileCoreServices
import AVFoundation
import VignetteFilter
import MetalKit

protocol EditingViewControllerDelegate : class {
    func finishEditing(vignette:Double)
}


class EditingViewController: UIViewController, MTKViewDelegate {
    
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var mtkview: MTKView!
    
    var context : CIContext!
    let displayImage : CIImage
    let vig = VignetteFilter()
    var initialVignette : Double = 0.7
    var canUndo = false
    weak var delegate : EditingViewControllerDelegate?
    
    var queue: MTLCommandQueue!

    
    init(displayImage:CIImage) {
        self.displayImage = displayImage
        super.init(nibName: "EditingViewController", bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.slider.value = Float(self.initialVignette)
        
        self.edgesForExtendedLayout = []
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(doCancel))
        self.navigationItem.leftBarButtonItem = cancel
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doDone))
        self.navigationItem.rightBarButtonItem = done
        
        if self.canUndo {
            let undo = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(doUndo))
            self.navigationItem.rightBarButtonItems = [done, undo]
        }
        
        self.mtkview.isOpaque = false // otherwise background is black
        // must have a "device"
        guard let device = MTLCreateSystemDefaultDevice() else {
            print("darn")
            return
        }
        self.mtkview.device = device
        
        // mode: draw on demand
        self.mtkview.isPaused = true
        self.mtkview.enableSetNeedsDisplay = true
        // other stuff
        self.context = CIContext(mtlDevice: device)
        self.queue = device.makeCommandQueue()
        
        self.mtkview.delegate = self
        // self.mtkview.backgroundColor = .black // just testing
        self.mtkview.setNeedsDisplay()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
        self.vig.setValue(self.displayImage, forKey: "inputImage")
        let val = Double(self.slider.value)
        self.vig.setValue(val, forKey:"inputPercentage")
        var output = self.vig.outputImage!
        // ok but for testing purposes let's not vignette yette
        //output = self.displayImage
        
        var r = view.bounds
        r.size = view.drawableSize
        
        r = AVMakeRect(aspectRatio: output.extent.size, insideRect: r)
        output = output.transformed(by: CGAffineTransform(scaleX: r.size.width/output.extent.size.width, y: r.size.height/output.extent.size.height))
        // okay, almost there! but we need to transform up or right to center in the view
        // wait, I just realized I can do that by offsetting the draw bounds origin
        
        // minimal dance required in order to draw: render, present, commit
        let buffer = self.queue.makeCommandBuffer()!
        self.context!.render(output,
                             to: view.currentDrawable!.texture,
                             commandBuffer: buffer,
                             bounds: CGRect(origin:CGPoint(x:-r.origin.x, y:-r.origin.y), size:view.drawableSize),
                             colorSpace: CGColorSpaceCreateDeviceRGB())
        buffer.present(view.currentDrawable!)
        buffer.commit()

    }


    
    @objc func doCancel (_ sender: Any?) {
        self.dismiss(animated:true)
    }
    
    @objc func doDone (_ sender: Any?) {
        self.dismiss(animated:true) {
            delay(0.1) {
                self.delegate?.finishEditing(vignette:Double(self.slider.value))
            }
        }
    }
    
    @objc func doUndo (_ sender: Any?) {
        self.dismiss(animated:true) {
            delay(0.1) {
                self.delegate?.finishEditing(vignette: -1) // signal for removal
            }
        }
    }

    @IBAction func doSlider(_ sender: Any?) {
        self.mtkview.setNeedsDisplay()
    }
    
    

}
