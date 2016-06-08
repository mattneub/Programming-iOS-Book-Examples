

import UIKit
import Photos
import ImageIO
import MobileCoreServices
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
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(300,300), contentMode: .aspectFit, options: nil) {
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
        var id : PHContentEditingInputRequestID = 0
        id = self.asset.requestContentEditingInput(with: options, completionHandler: {
            (input:PHContentEditingInput?, info:[NSObject : AnyObject]) in
            guard let input = input else {
                self.asset.cancelContentEditingInputRequest(id)
                return
            }
            self.input = input
            
            // now we give the user an editing interface...
            // ...using the input's displaySizeImage and adjustmentData
            
            let im = input.displaySizeImage!
            let sz = CGSize(im.size.width/4.0, im.size.height/4.0)
            let im2 = imageOfSize(sz) {
                // perhaps no need for this, but the image they give us is much larger than we need
                im.draw(in:CGRect(origin: CGPoint(), size: sz))
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
                if let vigAmount = NSKeyedUnarchiver.unarchiveObject(with: adj.data) as? Double {
                    if vigAmount >= 0.0 {
                        evc.initialVignette = vigAmount
                        evc.canUndo = true
                    }
                }
            }
            let nav = UINavigationController(rootViewController: evc)
            self.present(nav, animated: true)
        })
    }
    
    func finishEditing(vignette:Double) {
        // part two: obtain PHContentEditingOutput...
        // and apply editing to actual full size image
        let inurl = self.input.fullSizeImageURL!
        let inorient = self.input.fullSizeImageOrientation
        let output = PHContentEditingOutput(contentEditingInput:self.input)
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
            return CIContext().createCGImage(ci, from: ci.extent)
        }()
        
        let dest = CGImageDestinationCreateWithURL(outurl, kUTTypeJPEG, 1, nil)!
        CGImageDestinationAddImage(dest, outcgimage, [
            kCGImageDestinationLossyCompressionQuality as String:1
            ] as CFDictionary)
        CGImageDestinationFinalize(dest)

        let data = NSKeyedArchiver.archivedData(withRootObject: vignette)
        output.adjustmentData = PHAdjustmentData(
            formatIdentifier: self.myidentifier, formatVersion: "1.0", data: data)

        // now we must tell the photo library to pick up the edited image
        PHPhotoLibrary.shared().performChanges({
            print("finishing")
            let req = PHAssetChangeRequest(for: self.asset)
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

