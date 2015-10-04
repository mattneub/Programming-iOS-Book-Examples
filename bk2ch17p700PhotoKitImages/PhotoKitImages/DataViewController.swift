

import UIKit
import Photos
import ImageIO
import MobileCoreServices
import MyVignetteFilter

class DataViewController: UIViewController, EditingViewControllerDelegate {
                            
    @IBOutlet var dataLabel: UILabel!
    @IBOutlet var frameview : UIView!
    @IBOutlet var iv : UIImageView!
    var asset: PHAsset!
    // var index : Int = -1
    var input : PHContentEditingInput!
    let myidentifier = "com.neuburg.matt.PhotoKitImages.vignette"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpInterface()
    }
    
    func setUpInterface() {
        guard let asset = self.asset else {
            self.dataLabel.text = ""
            self.iv.image = nil
            return
        }
        self.dataLabel.text = asset.description
        // okay, this is why we are here! fetch the image data!!!!!
        // we have to say quite specifically what "view" of image we want
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(300,300), contentMode: .AspectFit, options: nil) {
            (im:UIImage?, info:[NSObject : AnyObject]?) in
            // this block can be called multiple times
            // and you can see why: initially we might get a degraded version of the image
            // and in fact we do, as I show with logging
            if let im = im {
                print("set up interface: \(im.size)")
                self.iv.image = im
            }
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
            // print("here")
            // return false // just testing
            return adjustmentData.formatIdentifier == self.myidentifier
        }
        let asset = self.asset
        var id : PHContentEditingInputRequestID = 0
        id = asset.requestContentEditingInputWithOptions(options, completionHandler: {
            (input:PHContentEditingInput?, info:[NSObject : AnyObject]) in
            guard let input = input else {
                asset.cancelContentEditingInputRequest(id)
                return
            }
            self.input = input
            
            // now we give the user an editing interface...
            // ...using the input's displaySizeImage and adjustmentData
            
            let im = input.displaySizeImage!
            let sz = CGSizeMake(im.size.width/4.0, im.size.height/4.0)
            let im2 = imageOfSize(sz) {
                // perhaps no need for this, but the image they give us is much larger than we need
                im.drawInRect(CGRect(origin: CGPoint(), size: sz))
            }
            
            let evc = EditingViewController(displayImage:CIImage(image:im2)!)
            
            evc.delegate = self
            let adj : PHAdjustmentData? = input.adjustmentData
            print(adj)
//            do {
//                asset.cancelContentEditingInputRequest(id)
//                return
//            }
            if let adj = adj where adj.formatIdentifier == self.myidentifier {
                if let vigAmount = NSKeyedUnarchiver.unarchiveObjectWithData(adj.data) as? Double {
                    if vigAmount >= 0.0 {
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
        let input = self.input
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
            return CIContext(options: nil).createCGImage(ci, fromRect: ci.extent)
        }()
        
        let dest = CGImageDestinationCreateWithURL(outurl, kUTTypeJPEG, 1, nil)!
        CGImageDestinationAddImage(dest, outcgimage, [
            kCGImageDestinationLossyCompressionQuality as String:1
            ])
        CGImageDestinationFinalize(dest)

        let data = NSKeyedArchiver.archivedDataWithRootObject(vignette)
        output.adjustmentData = PHAdjustmentData(
            formatIdentifier: self.myidentifier, formatVersion: "1.0", data: data)

        // now we must tell the photo library to pick up the edited image
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            print("finishing")
            let asset = self.asset
            let req = PHAssetChangeRequest(forAsset: asset)
            req.contentEditingOutput = output
            }, completionHandler: {
                (ok:Bool, err:NSError?) in
                print("in completion handler")
                // at the last minute, the user will get a special "modify?" dialog
                // if the user refuses, we will receive "false"
                if ok {
                    // in our case, since are already displaying this photo...
                    // ...we should now reload it
                    self.setUpInterface()
                } else {
                    print("phasset change request error: \(err)")
                }
        })
    }
    
}

