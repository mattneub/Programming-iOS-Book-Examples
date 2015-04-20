

import UIKit
import AVFoundation
import AVKit
import MobileCoreServices

class ViewController: UIViewController,
UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var redView: UIView!
    weak var picker : UIImagePickerController?
    
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
        let desiredType = kUTTypeImage as! String
        // let desiredType = kUTTypeMovie
        let arr = UIImagePickerController.availableMediaTypesForSourceType(.Camera) as! [String]
        println(arr)
        if find(arr, desiredType) == nil {
            println("no capture")
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = .Camera
        picker.mediaTypes = [desiredType]
        // picker.allowsEditing = true
        picker.delegate = self
        
        // user will get the "access the camera" system dialog at this point if necessary
        // if the user refuses, Very Weird Things happen...
        // better to get authorization beforehand
        
        self.presentViewController(picker, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
            println(info[UIImagePickerControllerReferenceURL])
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
                    case kUTTypeImage as! String:
                        if im != nil {
                            self.showImage(im!)
                        }
                    case kUTTypeMovie as! String:
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
        self.redView.subviews.map { ($0 as! UIView).removeFromSuperview() }
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
    
    func tap (g:UIGestureRecognizer) {
        self.picker?.takePicture()
    }


}
