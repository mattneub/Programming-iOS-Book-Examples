
import UIKit
import Photos
import PhotosUI
import GLKit
import OpenGLES
import MobileCoreServices
import AVFoundation

class PhotoEditingViewController: UIViewController, PHContentEditingController, GLKViewDelegate {

    @IBOutlet weak var glkview: GLKView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var seg: UISegmentedControl!
    var input: PHContentEditingInput!
    let myidentifier = "com.neuburg.matt.PhotoKitImages.vignette"
    var displayImage : CIImage!
    var context : CIContext!
    let vig = MyVignetteFilter()
    
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

    func canHandleAdjustmentData(adjustmentData: PHAdjustmentData?) -> Bool {
        return adjustmentData?.formatIdentifier == myidentifier
    }
    
    func glkView(view: GLKView!, drawInRect rect: CGRect) {
        glClearColor(1.0, 1.0, 1.0, 1.0)
        glClear(UInt32(GL_COLOR_BUFFER_BIT))
        
        var output = self.displayImage
        
        if self.seg.selectedSegmentIndex == 0 {
        
            self.vig.setValue(self.displayImage, forKey: "inputImage")
            let val = NSNumber(double: Double(self.slider.value))
            self.vig.setValue(val, forKey:"inputPercentage")
            output = self.vig.outputImage
            
        }
        
        var r = self.glkview.bounds
        r.size.width = CGFloat(self.glkview.drawableWidth)
        r.size.height = CGFloat(self.glkview.drawableHeight)
        
        r = AVMakeRectWithAspectRatioInsideRect(output.extent().size, r)
        
        self.context.drawImage(output, inRect: r, fromRect: output.extent())
    }

    
    @IBAction func doSlider(sender: AnyObject) {
        self.glkview.display()
    }
    @IBAction func doSegmentedControl(sender: AnyObject) {
        self.glkview.display()
    }
    
    func startContentEditingWithInput(contentEditingInput: PHContentEditingInput?, placeholderImage: UIImage) {
        // Present content for editing, and keep the contentEditingInput for use when closing the edit session.
        // If you returned YES from canHandleAdjustmentData:, contentEditingInput has the original image and adjustment data.
        // If you returned NO, the contentEditingInput has past edits "baked in".
        self.input = contentEditingInput!
        self.displayImage = CIImage(image:self.input.displaySizeImage)
        if let adj = input.adjustmentData {
            if adj.formatIdentifier == myidentifier && adj.data != nil {
                if let vigAmount = NSKeyedUnarchiver.unarchiveObjectWithData(adj.data) as? Double {
                    self.slider.value = Float(vigAmount)
                    self.seg.hidden = false
                }
            }
        }
        self.glkview.display()
    }

    func finishContentEditingWithCompletionHandler(completionHandler: ((PHContentEditingOutput!) -> Void)!) {
        // Update UI to reflect that editing has finished and output is being rendered.
        
        // Render and provide output on a background queue.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            // Create editing output from the editing input.
            let vignetteAmount = Double(self.slider.value)
            let input = self.input
            let inurl = input.fullSizeImageURL
            let output = PHContentEditingOutput(contentEditingInput: self.input)
            let outurl = output.renderedContentURL
            
            if self.seg.selectedSegmentIndex == 0 {
                let outcgimage = {
                    () -> CGImage in
                    let ci = CIImage(contentsOfURL: inurl)
                    self.vig.setValue(ci, forKey: "inputImage")
                    self.vig.setValue(vignetteAmount, forKey: "inputPercentage")
                    let outim = self.vig.outputImage
                    // this step is time-consuming; could be good to provide user feedback here
                    let outimcg = CIContext(options: nil).createCGImage(outim, fromRect: outim.extent())
                    return outimcg
                    }()
                let data = NSKeyedArchiver.archivedDataWithRootObject(vignetteAmount)
                output.adjustmentData = PHAdjustmentData(
                    formatIdentifier: self.myidentifier, formatVersion: "1.0", data: data)
                let dest = CGImageDestinationCreateWithURL(outurl, kUTTypeJPEG, 1, nil)
                CGImageDestinationAddImage(dest, outcgimage, [kCGImageDestinationLossyCompressionQuality as String:1])
                CGImageDestinationFinalize(dest)
            } else {
                output.adjustmentData = PHAdjustmentData(
                    formatIdentifier: self.myidentifier, formatVersion: "1.0", data: nil)
                let fm = NSFileManager.defaultManager()
                fm.copyItemAtURL(inurl, toURL: outurl, error: nil)
            }
            
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
