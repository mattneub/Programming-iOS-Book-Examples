

import UIKit
import MobileCoreServices
import Photos
import AVKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


class ViewController: UIViewController {
    @IBOutlet var redView : UIView!
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if self.traitCollection.userInterfaceIdiom == .pad {
            return .all
        }
        return .landscape
    }
    
    @discardableResult
    func determineStatus() -> Bool {
        // access permission dialog will appear automatically if necessary...
        // ...when we try to present the UIImagePickerController
        // however, things then proceed asynchronously
        // so it can look better to try to ascertain permission in advance
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            return true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization() {_ in}
            return false
        case .restricted:
            return false
        case .denied:
            // new iOS 8 feature: sane way of getting the user directly to the relevant prefs
            // I think the crash-in-background issue is now gone
            let alert = UIAlertController(title: "Need Authorization", message: "Wouldn't you like to authorize this app to use your Photos library?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel))
            alert.addAction(UIAlertAction(title: "OK", style: .default) {
                _ in
                let url = URL(string:UIApplicationOpenSettingsURLString)!
                UIApplication.shared.open(url)
            })
            self.present(alert, animated:true)
            return false
        }
    }
    
    /*
    New authorization strategy: check for authorization when we first appear,
    when we are brought back to the front,
    and when the user taps a button whose functionality needs authorization
    */
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.determineStatus()
        NotificationCenter.default.addObserver(self, selector: #selector(determineStatus), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func doPick (_ sender: Any!) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }
        
        // horrible
        // let src = UIImagePickerControllerSourceType.savedPhotosAlbum
        let src = UIImagePickerControllerSourceType.photoLibrary
        let ok = UIImagePickerController.isSourceTypeAvailable(src)
        if !ok {
            print("alas")
            return
        }
        
        let arr = UIImagePickerController.availableMediaTypes(for:src)
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
        // note that for .photoLibrary, iPhone app must permit portrait orientation
        // if we want a popover, on pad, we can do that; just uncomment next line
        picker.modalPresentationStyle = .popover
        self.present(picker, animated: true)
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
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return .landscape
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : Any]) { //
            print(info[UIImagePickerControllerReferenceURL])
            let url = info[UIImagePickerControllerMediaURL] as? URL
            var im = info[UIImagePickerControllerOriginalImage] as? UIImage
            let edim = info[UIImagePickerControllerEditedImage] as? UIImage
            if edim != nil {
                im = edim
            }
            self.dismiss(animated:true) {
                let type = info[UIImagePickerControllerMediaType] as? String
                if type != nil {
                    switch type! {
                    case kUTTypeImage as NSString as String: // this is freaking ridiculous, Swift
                        if im != nil {
                            self.showImage(im!)
                        }
                    case kUTTypeMovie as NSString as String:
                        if url != nil {
                            self.showMovie(url:url!)
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
    
    func showMovie(url:URL) {
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
    
}
