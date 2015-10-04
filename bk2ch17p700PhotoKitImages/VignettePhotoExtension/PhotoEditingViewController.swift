

import UIKit
import Photos
import PhotosUI
import GLKit
import OpenGLES
import MobileCoreServices
import AVFoundation
import MyVignetteFilter

class PhotoEditingViewController: UIViewController, PHContentEditingController, GLKViewDelegate {
    
    @IBOutlet weak var glkview: GLKView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var seg: UISegmentedControl!

    var input: PHContentEditingInput?
    
    let myidentifier = "com.neuburg.matt.PhotoKitImages.vignette"
    var displayImage : CIImage?
    var context : CIContext?
    let vig = MyVignetteFilter()

    
    @IBAction func doSlider(sender: AnyObject) {
        self.glkview.display()
    }
    @IBAction func doSegmentedControl(sender: AnyObject) {
        self.glkview.display()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        let eaglcontext = EAGLContext(API:.OpenGLES2)
        self.glkview.context = eaglcontext
        self.glkview.delegate = self
        
        self.context = CIContext(EAGLContext: self.glkview.context)
        
        self.seg.hidden = true
        self.seg.selectedSegmentIndex = 0
        
        self.title = "Vignette" // doesn't work, and I have not found a way to set the title
    }

    func glkView(view: GLKView, drawInRect rect: CGRect) {
        glClearColor(1.0, 1.0, 1.0, 1.0)
        glClear(UInt32(GL_COLOR_BUFFER_BIT))
        
        // orientation stuff worked out experimentally; I have no idea if it's right
        
        if var output = self.displayImage,
            let orient = self.input?.fullSizeImageOrientation {
                if self.seg.selectedSegmentIndex == 0 {
                    
                    self.vig.setValue(output, forKey: "inputImage")
                    let val = Double(self.slider.value)
                    self.vig.setValue(val, forKey:"inputPercentage")
                    output = self.vig.outputImage!
                    if !self.seg.hidden {
                        output = output.imageByApplyingOrientation(orient)
                    }
                    
                } else {
                    output = output.imageByApplyingOrientation(orient)
                }
                
                var r = self.glkview.bounds
                r.size.width = CGFloat(self.glkview.drawableWidth)
                r.size.height = CGFloat(self.glkview.drawableHeight)
                
                r = AVMakeRectWithAspectRatioInsideRect(output.extent.size, r)
                
                self.context?.drawImage(output, inRect: r, fromRect: output.extent)
        }
        
    }

    func canHandleAdjustmentData(adjustmentData: PHAdjustmentData?) -> Bool {
        return adjustmentData?.formatIdentifier == myidentifier
    }

    func startContentEditingWithInput(contentEditingInput: PHContentEditingInput?, placeholderImage: UIImage) {
        // Present content for editing, and keep the contentEditingInput for use when closing the edit session.
        // If you returned true from canHandleAdjustmentData:, contentEditingInput has the original image and adjustment data.
        // If you returned false, the contentEditingInput has past edits "baked in".
        self.input = contentEditingInput
        if let im = self.input?.displaySizeImage {
            let scale = max(im.size.width/self.glkview.bounds.width, im.size.height/self.glkview.bounds.height)
            let sz = CGSizeMake(im.size.width/scale, im.size.height/scale)
            let im2 = imageOfSize(sz) {
                // perhaps no need for this, but the image they give us is much larger than we need
                im.drawInRect(CGRect(origin: CGPoint(), size: sz))
            }

            self.displayImage = CIImage(image:im2)
            let adj : PHAdjustmentData? = self.input?.adjustmentData
            if let adj = adj where adj.formatIdentifier == self.myidentifier {
                if let vigAmount = NSKeyedUnarchiver.unarchiveObjectWithData(adj.data) as? Double {
                    if vigAmount >= 0.0 {
                        self.slider.value = Float(vigAmount)
                        self.seg.hidden = false
                    } else {
                        self.seg.hidden = true
                    }
                }
            }
        }
        self.glkview.display()

    }

    func finishContentEditingWithCompletionHandler(completionHandler: ((PHContentEditingOutput!) -> Void)!) {
        // Update UI to reflect that editing has finished and output is being rendered.
        
        // Render and provide output on a background queue.
        dispatch_async(dispatch_get_global_queue(CLong(DISPATCH_QUEUE_PRIORITY_DEFAULT), 0)) {
            let vignette = self.seg.selectedSegmentIndex == 0 ? Double(self.slider.value) : -1.0
            let input = self.input!
            let inurl = input.fullSizeImageURL!
            let inorient = input.fullSizeImageOrientation
            let output = PHContentEditingOutput(contentEditingInput: input)
            let outurl = output.renderedContentURL
            
            let outcgimage = {
                () -> CGImage in
                var ci = CIImage(contentsOfURL: inurl)!.imageByApplyingOrientation(inorient)
                if vignette >= 0.0 {
                    let vig = MyVignetteFilter()
                    vig.setValue(ci, forKey: "inputImage")
                    vig.setValue(vignette, forKey: "inputPercentage")
                    ci = vig.outputImage!
                }
                let outimcg = CIContext(options: nil).createCGImage(ci, fromRect: ci.extent)
                return outimcg
                }()
            
            let dest = CGImageDestinationCreateWithURL(outurl, kUTTypeJPEG, 1, nil)!
            CGImageDestinationAddImage(dest, outcgimage, [
                kCGImageDestinationLossyCompressionQuality as String:1
                ])
            CGImageDestinationFinalize(dest)
            
            let data = NSKeyedArchiver.archivedDataWithRootObject(vignette)
            output.adjustmentData = PHAdjustmentData(
                formatIdentifier: self.myidentifier, formatVersion: "1.0", data: data)
            
            // Call completion handler to commit edit to Photos.
            completionHandler?(output)
            
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
