

import UIKit
import Photos
import ImageIO
import MobileCoreServices

class DataViewController: UIViewController {
                            
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet var frameview : UIView!
    @IBOutlet var iv : UIImageView!
    var dataObject: AnyObject?
    var index : Int = -1

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpInterface()
    }
    
    func setUpInterface() {
        if let obj: AnyObject = dataObject {
            self.dataLabel!.text = obj.description
        } else {
            self.dataLabel!.text = ""
        }
        // okay, this is why we are here! fetch the image data!!!!!
        // we have to say quite specifically what "view" of image we want
        PHImageManager.defaultManager().requestImageForAsset(self.dataObject as PHAsset, targetSize: CGSizeMake(300,300), contentMode: .AspectFit, options: nil) {
            (im:UIImage!, info:[NSObject : AnyObject]!) -> Void in
            // this block can be called multiple times
            // and you can see why: initially we might get a degraded version of the image
            self.iv.image = im
        }
    }
    
    // simple editing example
    // everything depends upon PHContentEditingInput and PHContentEditingOutput classes
    // this entire thing (except for generating the actual edited CGImage) is a standard dance
    func doVignette() {
        let asset = self.dataObject as PHAsset
        let options = PHContentEditingInputRequestOptions()
        let myidentifier = "com.neuburg.matt.PhotoKitImages.vignette"
        options.canHandleAdjustmentData = {
            (adjustmentData : PHAdjustmentData!) in
            return adjustmentData.formatIdentifier == myidentifier
        }
        asset.requestContentEditingInputWithOptions(options, completionHandler: {
            (input:PHContentEditingInput!, info:[NSObject : AnyObject]!) in
            // if this is our adjustment data, then we can look inside to see...
            // what meaningful message we left for ourselves
            var undo = false
            if let adj = input.adjustmentData {
                if adj.formatIdentifier == myidentifier && adj.data != nil {
                    // as an example, let's undo the vignette if present
                    // this is possible because if we can handle adjustment data,
                    // the input image is the _original_ without our changes!
                    undo = true
                }
            }
            let inurl = input.fullSizeImageURL
            let output = PHContentEditingOutput(contentEditingInput: input)
            let outurl = output.renderedContentURL
            if !undo {
                println("vignetting")
                let outcgimage = {
                    () -> CGImage in
                    // at this point we do whatever editing means to us, returning a CGImage
                    let ci = CIImage(contentsOfURL: inurl)
                    let vig = MyVignetteFilter()
                    vig.setValue(ci, forKey: "inputImage")
                    let outim = vig.outputImage
                    // this step is time-consuming; could be good to provide user feedback here
                    let outimcg = CIContext(options: nil).createCGImage(outim, fromRect: outim.extent())
                    return outimcg
                    }()
                // *must* supply adjustment data or edit will fail (silently)
                let data = ("vignetted" as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                output.adjustmentData = PHAdjustmentData(
                    formatIdentifier: myidentifier, formatVersion: "1.0", data: data)
                let dest = CGImageDestinationCreateWithURL(outurl, kUTTypeJPEG, 1, nil)
                CGImageDestinationAddImage(dest, outcgimage, [kCGImageDestinationLossyCompressionQuality:1])
                CGImageDestinationFinalize(dest)
            } else {
                println("undoing")
                output.adjustmentData = PHAdjustmentData(
                    formatIdentifier: myidentifier, formatVersion: "1.0", data: nil)
                let fm = NSFileManager.defaultManager()
                fm.copyItemAtURL(inurl, toURL: outurl, error: nil)
            }
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                let req = PHAssetChangeRequest(forAsset: asset)
                req.contentEditingOutput = output
                }, completionHandler: {
                    (ok:Bool, err:NSError!) in
                    // at the last minute, the user will get a special "modify?" dialog
                    // if the user refuses, we will receive "false"
                    if ok {
                        // reload display of this photo
                        self.setUpInterface()
                    } else {
                        println(err)
                    }
            })
        })
    }

}

