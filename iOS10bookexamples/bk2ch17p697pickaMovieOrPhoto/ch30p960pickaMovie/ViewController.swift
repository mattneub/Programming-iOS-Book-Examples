

import UIKit
import MobileCoreServices
import Photos
import PhotosUI
import AVKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

func checkForPhotoLibraryAccess(andThen f:(()->())? = nil) {
    let status = PHPhotoLibrary.authorizationStatus()
    switch status {
    case .authorized:
        f?()
    case .notDetermined:
        PHPhotoLibrary.requestAuthorization() { status in
            if status == .authorized {
                DispatchQueue.main.async {
                    f?()
                }
            }
        }
    case .restricted:
        // do nothing
        break
    case .denied:
        // do nothing, or beg the user to authorize us in Settings
        break
    }
}


class ViewController: UIViewController {
    @IBOutlet var redView : UIView!
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if self.traitCollection.userInterfaceIdiom == .pad {
            return .all
        }
        return .landscape
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func doPick (_ sender: Any!) {
        
        checkForPhotoLibraryAccess {
        
            // horrible
            // let src = UIImagePickerControllerSourceType.savedPhotosAlbum
            let src = UIImagePickerControllerSourceType.photoLibrary
            guard UIImagePickerController.isSourceTypeAvailable(src)
                else { print("alas"); return }
            guard let arr = UIImagePickerController.availableMediaTypes(for:src)
                else { print("no available types"); return }
            let picker = UIImagePickerController()
            picker.sourceType = src
            picker.mediaTypes = [kUTTypeLivePhoto as String, kUTTypeImage as String, kUTTypeMovie as String]
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
}

// if we do nothing about cancel, cancels automatically
// if we do nothing about what was chosen, cancel automatically but of course now we have no access

// interesting problem is that we have no control over permitted orientations of picker
// that's why I subclass for the sake of the example

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // this has no effect
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return .landscape
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : Any]) { //
            print(info[UIImagePickerControllerReferenceURL] as Any)
            let url = info[UIImagePickerControllerMediaURL] as? URL
            var im = info[UIImagePickerControllerOriginalImage] as? UIImage
            if let ed = info[UIImagePickerControllerEditedImage] as? UIImage {
                im = ed
            }
            let live = info[UIImagePickerControllerLivePhoto] as? PHLivePhoto
            self.dismiss(animated:true) {
                if let mediatype = info[UIImagePickerControllerMediaType],
                    let type = mediatype as? NSString {
                        switch type {
                        case kUTTypeLivePhoto:
                            if live != nil {
                                self.showLivePhoto(live!)
                            }
                        case kUTTypeImage:
                            if im != nil {
                                self.showImage(im!)
                            }
                        case kUTTypeMovie:
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
    
    func showLivePhoto(_ ph:PHLivePhoto) {
        self.clearAll()
        let v = PHLivePhotoView(frame:self.redView.bounds)
        v.contentMode = .scaleAspectFit
        v.livePhoto = ph
        self.redView.addSubview(v)
    }
    
}
