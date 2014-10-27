

import UIKit
import AVFoundation
import MobileCoreServices

class ViewController: UIViewController,
UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var iv : UIImageView!
    @IBOutlet var picker : UIImagePickerController!
    
    func determineStatus() -> Bool {
        let status = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        switch status {
        case .Authorized:
            return true
        case .NotDetermined:
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: nil)
            return false
        case .Restricted:
            return false
        case .Denied:
            let alert = UIAlertController(
                title: "Need Authorization",
                message: "Wouldn't you like to authorize this app " +
                "to use the camera?",
                preferredStyle: .Alert)
            alert.addAction(UIAlertAction(
                title: "No", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(
                title: "OK", style: .Default, handler: {
                    _ in
                    let url = NSURL(string:UIApplicationOpenSettingsURLString)!
                    UIApplication.sharedApplication().openURL(url)
            }))
            self.presentViewController(alert, animated:true, completion:nil)
            return false
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.determineStatus()
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "determineStatus",
            name: UIApplicationWillEnterForegroundNotification,
            object: nil)
    }

    
    @IBAction func doTake (sender:AnyObject!) {
        let ok = UIImagePickerController.isSourceTypeAvailable(.Camera)
        if (!ok) {
            println("no camera")
            return
        }
        let arr = UIImagePickerController.availableMediaTypesForSourceType(.Camera) as [String]
        if find(arr, kUTTypeImage) == nil {
            println("no stills")
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = .Camera
        picker.mediaTypes = [kUTTypeImage]
        // picker.allowsEditing = true
        picker.delegate = self
        
        
        // ====
        /*
        picker.showsCameraControls = false
        let f = self.view.window!.bounds
        let h : CGFloat = 53
        let v = UIView(frame:f)
        let v2 = UIView(frame:CGRectMake(0,f.size.height-h,f.size.width,h))
        v2.backgroundColor = UIColor.redColor()
        v.addSubview(v2)
        let lab = UILabel()
        lab.text = "Double tap to take a picture"
        lab.backgroundColor = UIColor.clearColor()
        lab.sizeToFit()
        lab.center = CGPointMake(v2.bounds.midX, v2.bounds.midY)
        v2.addSubview(lab)
        let t = UITapGestureRecognizer(target:self, action:"tap:")
        t.numberOfTapsRequired = 2
        v.addGestureRecognizer(t)
        picker.cameraOverlayView = v
        self.picker = picker
*/
        // ====
        
        // user will get the "access the camera" system dialog at this point if necessary
        // if the user refuses, Very Weird Things happen...
        self.presentViewController(picker, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        var im = info[UIImagePickerControllerOriginalImage] as UIImage?
        let edim = info[UIImagePickerControllerEditedImage] as UIImage?
        if edim != nil {
            im = edim
        }
        if im != nil {
            self.iv.image = im!
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        // user may get the "access photos" system dialog -- spurious?
        // saw this the first time but then could not reproduce
    }
    
    func tap (g:UIGestureRecognizer) {
        self.picker.takePicture()
    }


}
