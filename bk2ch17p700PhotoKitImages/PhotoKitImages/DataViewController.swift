

import UIKit
import Photos
import ImageIO
import MobileCoreServices

func imageOfSize(size:CGSize, closure:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}

class DataViewController: UIViewController, EditingViewControllerDelegate {
                            
    @IBOutlet var dataLabel: UILabel!
    @IBOutlet var frameview : UIView!
    @IBOutlet var iv : UIImageView!
    var dataObject: PHAsset!
    // var index : Int = -1
    var input : PHContentEditingInput!
    let myidentifier = "com.neuburg.matt.PhotoKitImages.vignette"


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpInterface()
    }
    
    func setUpInterface() {
        if self.dataObject == nil {
            self.dataLabel.text = ""
            self.iv.image = nil
            return
        }
        self.dataLabel.text = self.dataObject.description
        // okay, this is why we are here! fetch the image data!!!!!
        // we have to say quite specifically what "view" of image we want
        PHImageManager.defaultManager().requestImageForAsset(self.dataObject, targetSize: CGSizeMake(300,300), contentMode: .AspectFit, options: nil) {
            (im:UIImage!, info:[NSObject : AnyObject]!) in
            // this block can be called multiple times
            // and you can see why: initially we might get a degraded version of the image
            // and in fact we do, as I show with logging
            println(im.size)
            self.iv.image = im
        }
    }
    
    // simple editing example
    // everything depends upon PHContentEditingInput and PHContentEditingOutput classes
    
    func doVignette() {
        // part one: standard dance to obtain PHContentEditingInput; hang on to it for later
        let options = PHContentEditingInputRequestOptions()
        // note that if we reply true to canHandle..., then we will be handed the *original* photo + data
        // thus we can continue our edit where we left off, or remove it (and I illustrate both here)
        options.canHandleAdjustmentData = {
            (adjustmentData : PHAdjustmentData!) in
            return adjustmentData.formatIdentifier == self.myidentifier
        }
        let asset = self.dataObject
        asset.requestContentEditingInputWithOptions(options, completionHandler: {
            (input:PHContentEditingInput!, info:[NSObject : AnyObject]!) in
            self.input = input
            
            // now we give the user an editing interface...
            // ...using the input's displaySizeImage and adjustmentData
            
            let im = input.displaySizeImage
            let sz = CGSizeMake(im.size.width/4.0, im.size.height/4.0)
            let im2 = imageOfSize(sz) {
                // perhaps no need for this, but the image they give us is much larger than we need
                im.drawInRect(CGRect(origin: CGPoint(), size: sz))
            }
            
            let evc = EditingViewController(displayImage:CIImage(image:im2))
            
            evc.delegate = self
            if let adj = input.adjustmentData {
                if adj.formatIdentifier == self.myidentifier && adj.data != nil {
                    if let vigAmount = NSKeyedUnarchiver.unarchiveObjectWithData(adj.data) as? Double {
                        evc.initialVignette = vigAmount
                        evc.canUndo = true
                    }
                }
            }
            let nav = UINavigationController(rootViewController: evc)
            self.presentViewController(nav, animated: true, completion: nil)
        })
    }
    
    func finishEditingWithVignette(vignette:Double) {
        // part two: obtain PHContentEditingOutput...
        // and apply editing to actual full size image
        let vignetteAmount = NSNumber(double:vignette)
        let input = self.input
        let inurl = input.fullSizeImageURL
        let output = PHContentEditingOutput(contentEditingInput: input)
        let outurl = output.renderedContentURL
        // cute feature: if vignette is -1, this signals we should remove the vignette
        // in that case, we substitute the original image and store nil data in adjustment
        if vignette < 0 {
            output.adjustmentData = PHAdjustmentData(
                formatIdentifier: myidentifier, formatVersion: "1.0", data: nil)
            let fm = NSFileManager.defaultManager()
            fm.copyItemAtURL(inurl, toURL: outurl, error: nil)
        } else {
            let outcgimage = {
                () -> CGImage in
                // at this point we do whatever editing means to us, returning a CGImage
                let ci = CIImage(contentsOfURL: inurl)
                let vig = MyVignetteFilter()
                vig.setValue(ci, forKey: "inputImage")
                vig.setValue(vignetteAmount, forKey: "inputPercentage")
                let outim = vig.outputImage
                // this step is time-consuming; could be good to provide user feedback here
                let outimcg = CIContext(options: nil).createCGImage(outim, fromRect: outim.extent())
                return outimcg
                }()
            // *must* supply adjustment data or edit will fail (silently)
            let data = NSKeyedArchiver.archivedDataWithRootObject(vignetteAmount)
            output.adjustmentData = PHAdjustmentData(
                formatIdentifier: self.myidentifier, formatVersion: "1.0", data: data)
            let dest = CGImageDestinationCreateWithURL(outurl, kUTTypeJPEG, 1, nil)
            CGImageDestinationAddImage(dest, outcgimage, [kCGImageDestinationLossyCompressionQuality as String:1])
            CGImageDestinationFinalize(dest)
        }
        // now we must tell the photo library to pick up the edited image
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let asset = self.dataObject
            let req = PHAssetChangeRequest(forAsset: asset)
            req.contentEditingOutput = output
            }, completionHandler: {
                (ok:Bool, err:NSError!) in
                // at the last minute, the user will get a special "modify?" dialog
                // if the user refuses, we will receive "false"
                if ok {
                    // in our case, since are already displaying this photo...
                    // ...we should now reload it
                    self.setUpInterface()
                } else {
                    println(err)
                }
        })
    }
    
}

