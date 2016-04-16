

import UIKit
import AVFoundation
import AVKit
import MobileCoreServices

func imageOfSize(_ size:CGSize, closure:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return result
}

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



class ViewController: UIViewController,
UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var iv : UIImageView!
    @IBOutlet var picker : UIImagePickerController!
    
    func determineStatus() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch status {
        case .authorized:
            return true
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: nil)
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
                title: "OK", style: .default, handler: {
                    _ in
                    let url = NSURL(string:UIApplicationOpenSettingsURLString)!
                    UIApplication.shared().open(url)
            }))
            self.present(alert, animated:true, completion:nil)
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
        let arr = UIImagePickerController.availableMediaTypes(for: cam)
        let desiredType = kUTTypeImage as NSString as String
        if arr?.index(of:desiredType) == nil {
            print("no stills")
            return
        }
        let picker = MyImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = [desiredType]
        picker.allowsEditing = true
        picker.delegate = self
        
        
        picker.showsCameraControls = false
        let f = self.view.window!.bounds
        let v = UIView(frame:f)
        let t = UITapGestureRecognizer(target:self, action:#selector(tap))
        t.numberOfTapsRequired = 2
        v.addGestureRecognizer(t)
        
        picker.cameraOverlayView = v
        self.picker = picker

        // user will get the "access the camera" system dialog at this point if necessary
        // if the user refuses, Very Weird Things happen...
        self.present(picker, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated:true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
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

    func navigationController(_ nc: UINavigationController, didShow vc: UIViewController, animated: Bool) {
        if vc is SecondViewController {
            nc.isToolbarHidden = true
            return
        }
        nc.isToolbarHidden = false
        
        let sz = CGSize(10,10)
        let im = imageOfSize(sz) {
            UIColor.black().withAlphaComponent(0.1).setFill()
            UIGraphicsGetCurrentContext()!.fill(CGRect(origin: CGPoint(), size: sz))
        }
        nc.toolbar.setBackgroundImage(im, forToolbarPosition: .any, barMetrics: .default)
        nc.toolbar.isTranslucent = true
        let b = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(doCancel))
        let lab = UILabel()
        lab.text = "Double tap to take a picture"
        lab.textColor = UIColor.white()
        lab.backgroundColor = UIColor.clear()
        lab.sizeToFit()
        let b2 = UIBarButtonItem(customView: lab)
        nc.topViewController!.toolbarItems = [b,b2]
        nc.topViewController!.title = "Retake"
    }

    func doCancel(_ sender:AnyObject) {
        self.dismiss(animated:true, completion: nil)
    }
    
    func doUse(_ im:UIImage?) {
        if im != nil {
            self.iv.image = im
        }
        self.dismiss(animated:true, completion: nil)
    }
    
}
