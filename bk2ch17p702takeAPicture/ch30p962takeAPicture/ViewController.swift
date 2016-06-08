

import UIKit
import AVFoundation
import AVKit
import MobileCoreServices
import Photos

class ViewController: UIViewController,
UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var redView: UIView!
    weak var picker : UIImagePickerController?
    
    @discardableResult
    func determineStatus() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(forMediaType:AVMediaTypeVideo)
        switch status {
        case .authorized:
            return true
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType:AVMediaTypeVideo, completionHandler:nil)
            return false
        case .restricted:
            return false
        case .denied:
            let alert = UIAlertController(
                title: "Need Authorization",
                message: "Wouldn't you like to authorize this app " +
                "to use the camera?",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: "No", style: .cancel))
            alert.addAction(UIAlertAction(
                title: "OK", style: .default) {
                    _ in
                    let url = NSURL(string:UIApplicationOpenSettingsURLString)!
                    UIApplication.shared().open(url)
            })
            self.present(alert, animated:true)
            return false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.determineStatus()
        NSNotificationCenter.default().addObserver(self,
            selector: #selector(determineStatus),
            name: UIApplicationWillEnterForegroundNotification,
            object: nil)
    }
    
    
    @IBAction func doTake (_ sender:AnyObject!) {
        let cam = UIImagePickerControllerSourceType.camera
        let ok = UIImagePickerController.isSourceTypeAvailable(cam)
        if (!ok) {
            print("no camera")
            return
        }
        let desiredType = kUTTypeImage as NSString as String
        // let desiredType = kUTTypeMovie as NSString as String
        let arr = UIImagePickerController.availableMediaTypes(for:cam)
        print(arr)
        if arr?.index(of:desiredType) == nil {
            print("no capture")
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = [desiredType]
        // picker.allowsEditing = true
        picker.delegate = self
        
        // user will get the "access the camera" system dialog at this point if necessary
        // if the user refuses, Very Weird Things happen...
        // better to get authorization beforehand
        
        self.present(picker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated:true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            print(info[UIImagePickerControllerReferenceURL])
            let url = info[UIImagePickerControllerMediaURL] as? NSURL
            var im = info[UIImagePickerControllerOriginalImage] as? UIImage
            let edim = info[UIImagePickerControllerEditedImage] as? UIImage
            if edim != nil {
                im = edim
            }
            self.dismiss(animated:true) {
                let type = info[UIImagePickerControllerMediaType] as? String
                if type != nil {
                    switch type! {
                    case kUTTypeImage as NSString as String:
                        if im != nil {
                            self.showImage(im!)
                            // showing how simple it is to save into the Camera Roll
                            let lib = PHPhotoLibrary.shared()
                            lib.performChanges({
                                PHAssetChangeRequest.creationRequestForAsset(from: im!)
                                })
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
            av.willMove(toParentViewController: nil)
            av.view.removeFromSuperview()
            av.removeFromParentViewController()
        }
        self.redView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    func showImage(_ im:UIImage) {
        self.clearAll()
        let iv = UIImageView(image:im)
        iv.contentMode = .scaleAspectFit
        iv.frame = self.redView.bounds
        self.redView.addSubview(iv)
    }
    
    func showMovie(_ url:NSURL) {
        self.clearAll()
        let av = AVPlayerViewController()
        let player = AVPlayer(url:url)
        av.player = player
        self.addChildViewController(av)
        av.view.frame = self.redView.bounds
        av.view.backgroundColor = self.redView.backgroundColor
        self.redView.addSubview(av.view)
        av.didMove(toParentViewController: self)
    }
    
    func tap (g:UIGestureRecognizer) {
        self.picker?.takePicture()
    }
    
    
}
