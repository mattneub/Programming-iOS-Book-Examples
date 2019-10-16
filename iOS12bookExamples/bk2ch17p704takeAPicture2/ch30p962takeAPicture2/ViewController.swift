

import UIKit
import AVFoundation
import AVKit
import MobileCoreServices

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


func checkForMovieCaptureAccess(andThen f:(()->())? = nil) {
    let status = AVCaptureDevice.authorizationStatus(for:.video)
    switch status {
    case .authorized:
        f?()
    case .notDetermined:
        AVCaptureDevice.requestAccess(for:.video) { granted in
            if granted {
                DispatchQueue.main.async {
                    f?()
                }
            }
        }
    case .restricted:
        // do nothing
        break
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
            let url = URL(string:UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url)
        })
        UIApplication.shared.delegate!.window!!.rootViewController!.present(alert, animated:true)
    }
}




class ViewController: UIViewController,
UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var iv : UIImageView!
    @IBOutlet var picker : UIImagePickerController!
    

    
    @IBAction func doTake (_ sender: Any!) {
        checkForMovieCaptureAccess(andThen: self.reallyTake)
    }
    
    
    func reallyTake() {
        let src = UIImagePickerController.SourceType.camera
        guard UIImagePickerController.isSourceTypeAvailable(src) else {return}

        guard UIImagePickerController.availableMediaTypes(for:src) != nil else {return}

        let picker = UIImagePickerController()
        picker.sourceType = src
        picker.mediaTypes = [kUTTypeImage as String]
        picker.allowsEditing = true
        picker.delegate = self
        
        
        picker.showsCameraControls = false
        let f = self.view.window!.bounds
        let v = UIView(frame:f)
        
        picker.cameraOverlayView = v
        self.picker = picker

        self.present(picker, animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated:true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let im = info[.originalImage] as? UIImage
                else {return}
            let svc = SecondViewController(image:im)
            picker.pushViewController(svc, animated: true)
    }
    
    @objc func tap (_ g:UIGestureRecognizer) {
        self.picker.takePicture()
    }

    func navigationController(_ nc: UINavigationController, didShow vc: UIViewController, animated: Bool) {
        if vc is SecondViewController {
            nc.isToolbarHidden = true
            return
        }
        nc.isToolbarHidden = false
        
        let sz = CGSize(10,10)
        let r = UIGraphicsImageRenderer(size:sz)
        let im = r.image { ctx in
            UIColor.black.withAlphaComponent(0.1).setFill()
            ctx.fill(CGRect(origin: .zero, size: sz))
        }
        nc.toolbar.setBackgroundImage(im, forToolbarPosition: .any, barMetrics: .default)
        nc.toolbar.isTranslucent = true
        let b = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(doCancel))
        let lab = UILabel()
        lab.text = "Double tap to take a picture"
        lab.textColor = .white
        lab.backgroundColor = .clear
        lab.sizeToFit()
        let b2 = UIBarButtonItem(customView: lab)
        nc.topViewController!.toolbarItems = [b,b2]
        nc.topViewController!.title = "Retake"
        
        let t = UITapGestureRecognizer(target:self, action:#selector(tap))
        t.numberOfTapsRequired = 2
        nc.topViewController!.view.addGestureRecognizer(t)
    }

    @objc func doCancel(_ sender: Any) {
        self.dismiss(animated:true)
    }
    
    func doUse(_ im:UIImage?) {
        if im != nil {
            self.iv.image = im
        }
        self.dismiss(animated:true)
    }
    
}
