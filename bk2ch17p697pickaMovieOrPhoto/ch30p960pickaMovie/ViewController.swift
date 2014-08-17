

import UIKit
import MediaPlayer
import MobileCoreServices
import Photos

class ViewController: UIViewController {
    var mpc : MPMoviePlayerController!
    var status = PHAuthorizationStatus.NotDetermined
    @IBOutlet var redView : UIView!
    
    override func supportedInterfaceOrientations() -> Int {
        if self.traitCollection.userInterfaceIdiom == .Pad {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
        return Int(UIInterfaceOrientationMask.Landscape.toRaw())
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // access permission dialog will appear automatically if necessary...
        // ...when we try to present the UIImagePickerController
        // however, things then proceed asynchronously
        // so it can look better to try to ascertain permission in advance
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .NotDetermined:
            PHPhotoLibrary.requestAuthorization({
                status in
                self.status = status
            })
        default:
            self.status = status
        }
    }
    
    @IBAction func doPick (sender:AnyObject!) {
        // by this time we have status, so we can bow out or whatever
        if self.status != .Authorized {
            // might do something here if denied, like put up an alert asking for authorization
            println("not authorized")
            return
        }
        // NB if user previously denied, then authorizes us in Settings while we're running,
        // **we will crash in the background**
        // I've always regarded this as a bug...
        
        let src = UIImagePickerControllerSourceType.PhotoLibrary
        let ok = UIImagePickerController.isSourceTypeAvailable(src)
        if !ok {
            println("alas")
            return
        }
        
        self.mpc?.pause() // don't play behind picker
        
        let arr = UIImagePickerController.availableMediaTypesForSourceType(src)
        let picker = MyImagePickerController() // see comments below for reason
        picker.sourceType = src
        picker.mediaTypes = arr
        picker.delegate = self
        
        picker.allowsEditing = false // try true
        
        // this will automatically be fullscreen on phone and pad, looks fine
        // note that for .PhotoLibrary, iPhone app must permit portrait orientation
        // if we want a popover, on pad, we can do that; just uncomment next line
        // picker.modalPresentationStyle = .Popover
        self.presentViewController(picker, animated: true, completion: nil)
        // ignore:
        if let pop = picker.popoverPresentationController {
            let v = sender as UIView
            pop.sourceView = v
            pop.sourceRect = v.bounds
        }
        
    }
}

// if we do nothing about cancel, cancels automatically
// if we do nothing about what was chosen, cancel automatically but of course now we have no access

// interesting problem is that we have no control over permitted orientations of picker
// seems like a bug; can work around this by subclassing

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController!,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
            let url = info[UIImagePickerControllerMediaURL] as NSURL?
            var im = info[UIImagePickerControllerOriginalImage] as UIImage?
            var edim = info[UIImagePickerControllerEditedImage] as UIImage?
            if edim != nil {
                im = edim
            }
            self.dismissViewControllerAnimated(true) {
                let type = info[UIImagePickerControllerMediaType] as NSString
                // idiotic foo to evade casting issues; Swift doesn't know CFString is NSString?
                let typeim = kUTTypeImage as NSString
                let typemovie = kUTTypeMovie as NSString
                if type != nil {
                    switch type {
                    case typeim:
                        if im != nil {
                            self.showImage(im!)
                        }
                    case typemovie:
                        if url != nil {
                            self.showMovie(url!)
                        }
                    default:break
                    }
                }
            }
    }
    
    func showImage(im:UIImage) {
        let iv = UIImageView(image:im)
        iv.contentMode = .ScaleAspectFit
        iv.frame = self.redView.bounds
        self.redView.subviews.map { ($0 as UIView).removeFromSuperview() }
        self.redView.addSubview(iv)
    }
    
    func showMovie(url:NSURL) {
        let mp = MPMoviePlayerController(contentURL: url)
        self.mpc = mp
        mp.shouldAutoplay = false
        mp.view.frame = self.redView.bounds
        mp.backgroundView.backgroundColor = self.redView.backgroundColor
        self.redView.subviews.map { ($0 as UIView).removeFromSuperview() }
        self.redView.addSubview(mp.view)
        mp.prepareToPlay()
    }
    
}
