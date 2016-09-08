

import UIKit
import Photos
import PhotosUI
import GLKit
import OpenGLES
import MobileCoreServices
import AVFoundation
import VignetteFilter

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



class PhotoEditingViewController: UIViewController, PHContentEditingController, GLKViewDelegate {
    
    @IBOutlet weak var glkview: GLKView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var seg: UISegmentedControl!

    var input: PHContentEditingInput?
    
    let myidentifier = "com.neuburg.matt.PhotoKitImages.vignette"
    var displayImage : CIImage?
    var context : CIContext?
    let vig = VignetteFilter()

    
    @IBAction func doSlider(_ sender: Any) {
        self.glkview.display()
    }
    @IBAction func doSegmentedControl(_ sender: Any) {
        self.glkview.display()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        let eaglcontext = EAGLContext(api:.openGLES2)!
        self.glkview.context = eaglcontext
        self.glkview.delegate = self
        
        self.context = CIContext(eaglContext: self.glkview.context)
        
        self.seg.isHidden = true
        self.seg.selectedSegmentIndex = 0
        
        self.title = "Vignette" // doesn't work, and I have not found a way to set the title
    }

    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(1.0, 1.0, 1.0, 1.0)
        glClear(UInt32(GL_COLOR_BUFFER_BIT))
        
        // orientation stuff worked out experimentally; I have no idea if it's right
        
        if let output = self.displayImage, // removed if var, perhaps unnecessarily but it's clearer without
            let orient = self.input?.fullSizeImageOrientation {
                var output = output
                if self.seg.selectedSegmentIndex == 0 {
                    
                    self.vig.setValue(output, forKey: "inputImage")
                    let val = Double(self.slider.value)
                    self.vig.setValue(val, forKey:"inputPercentage")
                    output = self.vig.outputImage!
                    if !self.seg.isHidden {
                        output = output.applyingOrientation(orient)
                    }
                    
                } else {
                    output = output.applyingOrientation(orient)
                }
                
                var r = self.glkview.bounds
                r.size.width = CGFloat(self.glkview.drawableWidth)
                r.size.height = CGFloat(self.glkview.drawableHeight)
                
                r = AVMakeRect(aspectRatio: output.extent.size, insideRect: r)
                
                self.context?.draw(output, in: r, from: output.extent)
        }
        
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
            let scale = max(im.size.width/self.glkview.bounds.width, im.size.height/self.glkview.bounds.height)
            let sz = CGSize(im.size.width/scale, im.size.height/scale)
            let im2 = imageOfSize(sz) {
                // perhaps no need for this, but the image they give us is much larger than we need
                im.draw(in:CGRect(origin: .zero, size: sz))
            }

            self.displayImage = CIImage(image:im2)
            let adj : PHAdjustmentData? = self.input?.adjustmentData
            if let adj = adj, adj.formatIdentifier == self.myidentifier {
                if let vigAmount = NSKeyedUnarchiver.unarchiveObject(with:adj.data) as? Double {
                    if vigAmount >= 0.0 {
                        self.slider.value = Float(vigAmount)
                        self.seg.isHidden = false
                    } else {
                        self.seg.isHidden = true
                    }
                }
            }
        }
        self.glkview.display()

    }
    
    func finishContentEditing(completionHandler: @escaping (PHContentEditingOutput?) -> Void) {
        // Update UI to reflect that editing has finished and output is being rendered.
        
        // Render and provide output on a background queue.
        DispatchQueue.global(qos:.default).async {
            let vignette = self.seg.selectedSegmentIndex == 0 ? Double(self.slider.value) : -1.0
            let input = self.input!
            let inurl = input.fullSizeImageURL!
            let inorient = input.fullSizeImageOrientation
            let output = PHContentEditingOutput(contentEditingInput: input)
            let outurl = output.renderedContentURL
            
            let outcgimage = {
                () -> CGImage in
                var ci = CIImage(contentsOf: inurl)!.applyingOrientation(inorient)
                if vignette >= 0.0 {
                    let vig = VignetteFilter()
                    vig.setValue(ci, forKey: "inputImage")
                    vig.setValue(vignette, forKey: "inputPercentage")
                    ci = vig.outputImage!
                }
                let outimcg = CIContext().createCGImage(ci, from: ci.extent)!
                return outimcg
                }()
            
            let dest = CGImageDestinationCreateWithURL(outurl as CFURL, kUTTypeJPEG, 1, nil)!
            CGImageDestinationAddImage(dest, outcgimage, [
                kCGImageDestinationLossyCompressionQuality as String:1
                ] as CFDictionary)
            CGImageDestinationFinalize(dest)
            
            let data = NSKeyedArchiver.archivedData(withRootObject:vignette)
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
