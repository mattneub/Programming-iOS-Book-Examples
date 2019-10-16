

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
    let cicontext = CIContext()

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
        let opts = PHImageRequestOptions()
        opts.resizeMode = .exact
        opts.version = .current
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(600,600), contentMode: .aspectFit, options: opts) { im, info in
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
        options.canHandleAdjustmentData = { adjustmentData in
            // print("here")
            // return false // just testing
            return adjustmentData.formatIdentifier == self.myidentifier
        }
        var id : PHContentEditingInputRequestID = 0
        id = self.asset.requestContentEditingInput(with: options) {
            input, info in
            guard let input = input else {
                self.asset.cancelContentEditingInputRequest(id)
                return
            }
            self.input = input
            
            // now we give the user an editing interface...
            // ...using the input's displaySizeImage and adjustmentData
            
            let im = input.displaySizeImage!

            // for reasons that are totally unclear to me, this line doesn't work here...
            // (portrait images come out in landscape)
            // but it _does_ work in the photo editing extension (PhotoEditingViewController)
            // let evc = EditingViewController(displayImage:CIImage(image:im, options:[.applyOrientationProperty:true])!)
            let or = input.fullSizeImageOrientation
            let evc = EditingViewController(displayImage:CIImage(image: im)!.oriented(forExifOrientation:or))
            
            // oddly, I didn't have to do that before because I was drawing the image into an image graphics context
            // and using that — and that reoriented it!
            
            evc.delegate = self
            if let adj = input.adjustmentData,
                adj.formatIdentifier == self.myidentifier {
                if let vigNumber = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: adj.data),
                    let vigAmount = vigNumber as? Double {
                    print("got vigAmount", vigAmount)
                    if vigAmount >= 0.0 {
                        evc.initialVignette = vigAmount
                        evc.canUndo = true
                    }
                }
            }
            let nav = UINavigationController(rootViewController: evc)
            self.present(nav, animated: true)
        }
    }
    
    func finishEditing(vignette:Double) {
        // part two: obtain PHContentEditingOutput...
        // and apply editing to actual full size image
        
        let act = UIActivityIndicatorView(style: .whiteLarge)
        act.backgroundColor = .darkGray
        act.layer.cornerRadius = 3
        act.center = self.view.center
        self.view.addSubview(act)
        act.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async {

            let inurl = self.input.fullSizeImageURL!
            let output = PHContentEditingOutput(contentEditingInput:self.input)
            let outurl = output.renderedContentURL
            // okay, I now believe this next line is crucial for picking up orientation correctly
            // if we don't do that, we can't save back into the library
            var ci = CIImage(contentsOf: inurl, options: [.applyOrientationProperty:true])!
            let space = ci.colorSpace!
            if vignette >= 0.0 {
                let vig = VignetteFilter()
                vig.setValue(ci, forKey: "inputImage")
                vig.setValue(vignette, forKey: "inputPercentage")
                ci = vig.outputImage!
            }
            // new in iOS 10
            // warning: this is time-consuming! (even more than how I was doing it before)
            try! CIContext().writeJPEGRepresentation(of: ci, to: outurl, colorSpace: space)

            let data = try! NSKeyedArchiver.archivedData(withRootObject: vignette, requiringSecureCoding: true)
            output.adjustmentData = PHAdjustmentData(
                formatIdentifier: self.myidentifier, formatVersion: "1.0", data: data)

            // now we must tell the photo library to pick up the edited image
            // all this main-queue-plus-delay stuff seems to be genuinely necessary
            DispatchQueue.main.async {
                PHPhotoLibrary.shared().performChanges({
                    print("finishing", self.asset)
                    typealias Req = PHAssetChangeRequest
                    let req = Req(for: self.asset)
                    req.contentEditingOutput = output
                }) { ok, err in
                    DispatchQueue.main.async {
                        print("in completion handler")
                        // at the last minute, the user will get a special "modify?" dialog
                        // if the user refuses, we will receive "false"
                        if ok {
                            // in our case, since are already displaying this photo...
                            // ...we should now reload it
                            // but for some reason I'm having trouble talking to the library, add delay
                            // needs to be quite lengthy! surely this is not a correct solution...????
                            delay(0.5) {
                                act.removeFromSuperview()
                                self.setUpInterface()
                            }
                        } else {
                            act.removeFromSuperview()
                            print("phasset change request error: \(err as Any)")
                        }
                    }
                }
            }
            
        }
    }
    
}

