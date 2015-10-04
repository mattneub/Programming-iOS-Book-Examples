

import UIKit
import AVFoundation
import AVKit
import MobileCoreServices

func imageOfSize(size:CGSize, closure:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}

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
        let cam = UIImagePickerControllerSourceType.Camera
        let ok = UIImagePickerController.isSourceTypeAvailable(cam)
        if (!ok) {
            print("no camera")
            return
        }
        let arr = UIImagePickerController.availableMediaTypesForSourceType(cam)
        let desiredType = kUTTypeImage as NSString as String
        if arr?.indexOf(desiredType) == nil {
            print("no stills")
            return
        }
        let picker = MyImagePickerController()
        picker.sourceType = .Camera
        picker.mediaTypes = [desiredType]
        picker.allowsEditing = true
        picker.delegate = self
        
        
        picker.showsCameraControls = false
        let f = self.view.window!.bounds
        let v = UIView(frame:f)
        let t = UITapGestureRecognizer(target:self, action:"tap:")
        t.numberOfTapsRequired = 2
        v.addGestureRecognizer(t)
        
        picker.cameraOverlayView = v
        self.picker = picker

        // user will get the "access the camera" system dialog at this point if necessary
        // if the user refuses, Very Weird Things happen...
        self.presentViewController(picker, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let im = info[UIImagePickerControllerOriginalImage] as? UIImage
        if im == nil {
            return
        }
        let svc = SecondViewController(image:im)
        picker.pushViewController(svc, animated: true)
    }
    
    func tap (g:UIGestureRecognizer) {
        self.picker.takePicture()
    }

    func navigationController(nc: UINavigationController, didShowViewController vc: UIViewController, animated: Bool) {
        if vc is SecondViewController {
            nc.toolbarHidden = true
            return
        }
        nc.toolbarHidden = false
        
        let sz = CGSizeMake(10,10)
        let im = imageOfSize(sz) {
            UIColor.blackColor().colorWithAlphaComponent(0.1).setFill()
            CGContextFillRect(UIGraphicsGetCurrentContext()!, CGRect(origin: CGPoint(), size: sz))
        }
        nc.toolbar.setBackgroundImage(im, forToolbarPosition: .Any, barMetrics: .Default)
        nc.toolbar.translucent = true
        let b = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "doCancel:")
        let lab = UILabel()
        lab.text = "Double tap to take a picture"
        lab.textColor = UIColor.whiteColor()
        lab.backgroundColor = UIColor.clearColor()
        lab.sizeToFit()
        let b2 = UIBarButtonItem(customView: lab)
        nc.topViewController!.toolbarItems = [b,b2]
        nc.topViewController!.title = "Retake"
    }

    func doCancel(sender:AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func doUse(im:UIImage?) {
        if im != nil {
            self.iv.image = im
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
