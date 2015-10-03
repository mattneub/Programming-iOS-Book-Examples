

import UIKit
import MobileCoreServices
import Photos
import AVKit
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class ViewController: UIViewController {
    @IBOutlet var redView : UIView!
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if self.traitCollection.userInterfaceIdiom == .Pad {
            return .All
        }
        return .Landscape
    }
    
    func determineStatus() -> Bool {
        // access permission dialog will appear automatically if necessary...
        // ...when we try to present the UIImagePickerController
        // however, things then proceed asynchronously
        // so it can look better to try to ascertain permission in advance
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .Authorized:
            return true
        case .NotDetermined:
            PHPhotoLibrary.requestAuthorization() {_ in}
            return false
        case .Restricted:
            return false
        case .Denied:
            // new iOS 8 feature: sane way of getting the user directly to the relevant prefs
            // I think the crash-in-background issue is now gone
            let alert = UIAlertController(title: "Need Authorization", message: "Wouldn't you like to authorize this app to use your Photos library?", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                _ in
                let url = NSURL(string:UIApplicationOpenSettingsURLString)!
                UIApplication.sharedApplication().openURL(url)
            }))
            self.presentViewController(alert, animated:true, completion:nil)
            return false
        }
    }
    
    /*
    New authorization strategy: check for authorization when we first appear,
    when we are brought back to the front,
    and when the user taps a button whose functionality needs authorization
    */
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.determineStatus()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "determineStatus", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBAction func doPick (sender:AnyObject!) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }
        
        // horrible
        // let src = UIImagePickerControllerSourceType.SavedPhotosAlbum
        let src = UIImagePickerControllerSourceType.PhotoLibrary
        let ok = UIImagePickerController.isSourceTypeAvailable(src)
        if !ok {
            print("alas")
            return
        }
        
        let arr = UIImagePickerController.availableMediaTypesForSourceType(src)
        if arr == nil {
            print("no available types")
            return
        }
        let picker = MyImagePickerController() // see comments below for reason
        picker.sourceType = src
        picker.mediaTypes = arr!
        picker.delegate = self
        
        picker.allowsEditing = false // try true
        
        // this will automatically be fullscreen on phone and pad, looks fine
        // note that for .PhotoLibrary, iPhone app must permit portrait orientation
        // if we want a popover, on pad, we can do that; just uncomment next line
        picker.modalPresentationStyle = .Popover
        self.presentViewController(picker, animated: true, completion: nil)
        // ignore:
        if let pop = picker.popoverPresentationController {
            let v = sender as! UIView
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
    
    // this has no effect
    func navigationControllerSupportedInterfaceOrientations(navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return .Landscape
    }
    
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) { //
            print(info[UIImagePickerControllerReferenceURL])
            let url = info[UIImagePickerControllerMediaURL] as? NSURL
            var im = info[UIImagePickerControllerOriginalImage] as? UIImage
            let edim = info[UIImagePickerControllerEditedImage] as? UIImage
            if edim != nil {
                im = edim
            }
            self.dismissViewControllerAnimated(true) {
                let type = info[UIImagePickerControllerMediaType] as? String
                if type != nil {
                    switch type! {
                    case kUTTypeImage as NSString as String: // this is freaking ridiculous, Swift
                        if im != nil {
                            self.showImage(im!)
                        }
                    case kUTTypeMovie as NSString as String:
                        if url != nil {
                            self.showMovie(url!)
                        }
                    default:break
                    }
                }
            }
    }
    
    func clearAll() {
        if self.childViewControllers.count > 0 {
            let av = self.childViewControllers[0] as! AVPlayerViewController
            av.willMoveToParentViewController(nil)
            av.view.removeFromSuperview()
            av.removeFromParentViewController()
        }
        self.redView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    func showImage(im:UIImage) {
        self.clearAll()
        let iv = UIImageView(image:im)
        iv.contentMode = .ScaleAspectFit
        iv.frame = self.redView.bounds
        self.redView.addSubview(iv)
    }
    
    func showMovie(url:NSURL) {
        self.clearAll()
        let av = AVPlayerViewController()
        let player = AVPlayer(URL:url)
        av.player = player
        self.addChildViewController(av)
        av.view.frame = self.redView.bounds
        av.view.backgroundColor = self.redView.backgroundColor
        self.redView.addSubview(av.view)
        av.didMoveToParentViewController(self)
    }
    
}
