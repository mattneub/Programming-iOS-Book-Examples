

import UIKit
import Photos
import PhotosUI
import MobileCoreServices
import AVFoundation
import VignetteFilter
import MetalKit

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



class PhotoEditingViewController: UIViewController, PHContentEditingController, MTKViewDelegate {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var seg: UISegmentedControl!
    @IBOutlet weak var mtkview: MTKView!

    var input: PHContentEditingInput?
    
    let myidentifier = "com.neuburg.matt.PhotoKitImages.vignette"
    var displayImage : CIImage?
    var context : CIContext?
    let vig = VignetteFilter()
    var queue: MTLCommandQueue?


    
    @IBAction func doSlider(_ sender: Any) {
        self.mtkview.setNeedsDisplay()
    }
    @IBAction func doSegmentedControl(_ sender: Any) {
        self.mtkview.setNeedsDisplay()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.seg.isHidden = true
        self.seg.selectedSegmentIndex = 0
        
        self.title = "Vignette" // doesn't work, and I have not found a way to set the title
        
        self.mtkview.isOpaque = false // otherwise background is black
        // must have a "device"
        guard let device = MTLCreateSystemDefaultDevice() else {
            print("darn")
            return
        }
        self.mtkview.device = device
        self.mtkview.framebufferOnly = false

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
        
        guard self.displayImage != nil else {return}
        
        self.vig.setValue(self.displayImage, forKey: "inputImage")
        let val = Double(self.slider.value)
        self.vig.setValue(val, forKey:"inputPercentage")
        var output = self.vig.outputImage!
        // but if removing, show unvignetted image
        if !self.seg.isHidden && self.seg.selectedSegmentIndex == 1 {
            output = self.displayImage!
        }
        
        var r = view.bounds
        r.size = view.drawableSize
        
        r = AVMakeRect(aspectRatio: output.extent.size, insideRect: r)
        output = output.transformed(by: CGAffineTransform(scaleX: r.size.width/output.extent.size.width, y: r.size.height/output.extent.size.height))
        // okay, almost there! but we need to transform up or right to center in the view
        // wait, I just realized I can do that by offsetting the draw bounds origin
        
        // minimal dance required in order to draw: render, present, commit
        guard let texture = self.mtkview.currentDrawable?.texture else {return}
        guard let buffer = self.queue?.makeCommandBuffer() else {return}
        self.context!.render(output,
                             to: texture,
                             commandBuffer: buffer,
                             bounds: CGRect(origin:CGPoint(x:-r.origin.x, y:-r.origin.y), size:view.drawableSize),
                             colorSpace: CGColorSpaceCreateDeviceRGB())
        guard let drawable = self.mtkview.currentDrawable else { return }
        buffer.present(drawable)
        buffer.commit()
        
    }

    func canHandle(_ adjustmentData: PHAdjustmentData) -> Bool {
        return adjustmentData.formatIdentifier == myidentifier
    }

    func startContentEditing(with contentEditingInput: PHContentEditingInput, placeholderImage: UIImage) {
        
        // Present content for editing, and keep the contentEditingInput for use when closing the edit session.
        // If you returned true from canHandleAdjustmentData:, contentEditingInput has the original image and adjustment data.
        // If you returned false, the contentEditingInput has past edits "baked in".
        
        self.input = contentEditingInput
        if let im = self.input?.displaySizeImage {

            self.displayImage = CIImage(image:im, options: [.applyOrientationProperty:true])!
            if let adj = self.input?.adjustmentData,
                adj.formatIdentifier == self.myidentifier {
                if let vigNumber = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: adj.data),
                    let vigAmount = vigNumber as? Double {
                    if vigAmount >= 0.0 {
                        self.slider.value = Float(vigAmount)
                        self.seg.isHidden = false
                    } else {
                        self.seg.isHidden = true
                    }
                }
            }
        }
        self.mtkview.setNeedsDisplay()

    }
    
    func finishContentEditing(completionHandler: @escaping ((PHContentEditingOutput?) -> Void)) {
        // Update UI to reflect that editing has finished and output is being rendered.
        
        // Render and provide output on a background queue.
        DispatchQueue.global(qos:.default).async {
            let vignette = self.seg.selectedSegmentIndex == 0 ? Double(self.slider.value) : -1.0
            let inurl = self.input!.fullSizeImageURL!
            let output = PHContentEditingOutput(contentEditingInput:self.input!)
            let outurl = output.renderedContentURL
            var ci = CIImage(contentsOf: inurl, options: [.applyOrientationProperty:true])!
            let space = ci.colorSpace!
            
            if vignette >= 0.0 {
                let vig = VignetteFilter()
                vig.setValue(ci, forKey: "inputImage")
                vig.setValue(vignette, forKey: "inputPercentage")
                ci = vig.outputImage!
            }
            try! CIContext().writeJPEGRepresentation(
                of: ci, to: outurl, colorSpace: space)
            
            let data = try! NSKeyedArchiver.archivedData(withRootObject: vignette, requiringSecureCoding: true)
            output.adjustmentData = PHAdjustmentData(
                formatIdentifier: self.myidentifier, formatVersion: "1.0", data: data)
            
            // Call completion handler to commit edit to Photos.
            completionHandler(output)
            
            // Clean up temporary files, etc.
        }
    }

    var shouldShowCancelConfirmation: Bool {
        // Determines whether a confirmation to discard changes should be shown to the user on cancel.
        // (Typically, this should be "true" if there are any unsaved changes.)
        return false
    }

    func cancelContentEditing() {
        // Clean up temporary files, etc.
        // May be called after finishContentEditingWithCompletionHandler: while you prepare output.
    }

}
