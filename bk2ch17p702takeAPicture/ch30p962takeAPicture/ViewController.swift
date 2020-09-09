

import UIKit
import AVFoundation
import AVKit
import MobileCoreServices
import Photos
import ImageIO

func checkForPhotoLibraryAccess(for level: PHAccessLevel = .readWrite, andThen f:(()->())? = nil) {
    let status = PHPhotoLibrary.authorizationStatus(for: level)
    switch status {
    case .authorized, .limited: // *
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
    @unknown default: fatalError()
    }
}

func checkForMicrophoneCaptureAccess(andThen f:(()->())? = nil) {
    let status = AVCaptureDevice.authorizationStatus(for:.audio)
    switch status {
    case .authorized:
        f?()
    case .notDetermined:
        AVCaptureDevice.requestAccess(for:.audio) { granted in
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
            "to use the microphone?",
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
    @unknown default: fatalError()
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
    @unknown default: fatalError()
    }
}




class ViewController: UIViewController,
UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var redView: UIView!
    weak var picker : UIImagePickerController?
        
    @IBAction func doTake (_ sender: Any) {
        checkForMovieCaptureAccess(andThen: self.micCheck)
    }
    
    func micCheck() {
        checkForMicrophoneCaptureAccess(andThen:self.reallyTake)
    }
    
    func reallyTake() {
        let src = UIImagePickerController.SourceType.camera
        guard UIImagePickerController.isSourceTypeAvailable(src) else {return}
        
        var which : Int {return 3} // 1, 2, 3
        let desiredTypes : [String] = {
            switch which {
            case 1: return [UTType.image.identifier]
            case 2: return [UTType.movie.identifier]
            case 3: return [UTType.image.identifier, UTType.movie.identifier]
            default: fatalError("hey")
            }
        }()
        // they are not going to let me take a live photo this way
        
        let picker = UIImagePickerController()
        picker.sourceType = src
        picker.mediaTypes = desiredTypes
        print(picker.mediaTypes) // if you include live photo, they throw it away
        picker.allowsEditing = false
        picker.delegate = self
        
        self.present(picker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated:true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            print(info[.phAsset] as Any)
            let url = info[.mediaURL] as? URL
            var image = info[.originalImage] as? UIImage
            if let edited = info[.editedImage] as? UIImage {
                image = edited
            }
            if let live = info[.livePhoto] {
                print("I got a live photo!") // nope
                _ = live
            }
            let imurl = info[.imageURL] as? URL
            print(imurl as Any)
            let metadata = info[.mediaMetadata] as? NSDictionary
            print(metadata as Any)
            self.dismiss(animated:true) {
                let mediatype = info[.mediaType]
                guard let type = mediatype as? String else {return}
                switch type {
                case UTType.image.identifier:
                    if image != nil {
                        self.showImage(image!)
                        // showing how simple it is to save into the Camera Roll
                        return;
                        checkForPhotoLibraryAccess {
                            var which : Int { return 1 }
                            switch which {
                            case 0: // simply add image to library
                                let lib = PHPhotoLibrary.shared()
                                lib.performChanges {
                                    typealias Req = PHAssetChangeRequest
                                    let req = Req.creationRequestForAsset(from: image!)
                                    // apply metadata info here, as desired
                                }
                            case 1: // add image while folding in the metadata
                                let jpeg = image!.jpegData(compressionQuality: 1)!
                                let src = CGImageSourceCreateWithData(jpeg as CFData, nil)!
                                let data = NSMutableData()
                                let uti = CGImageSourceGetType(src)!
                                let dest = CGImageDestinationCreateWithData(data as CFMutableData, uti, 1, nil)!
                                CGImageDestinationAddImageFromSource(dest, src, 0, metadata)
                                CGImageDestinationFinalize(dest)
                                let lib = PHPhotoLibrary.shared()
                                lib.performChanges {
                                    let req = PHAssetCreationRequest.forAsset()
                                    req.addResource(with: .photo, data: data as Data, options: nil)
                                }
                            default: break
                            }
                            
                        }
                    }
                case UTType.movie.identifier:
                    if url != nil {
                        self.showMovie(url!)
                    }
                default:break
                }
            }
    }
    
    func clearAll() {
        if self.children.count > 0 {
            let av = self.children[0] as! AVPlayerViewController
            av.willMove(toParent: nil)
            av.view.removeFromSuperview()
            av.removeFromParent()
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
    
    func showMovie(_ url:URL) {
        self.clearAll()
        let av = AVPlayerViewController()
        let player = AVPlayer(url:url)
        av.player = player
        self.addChild(av)
        av.view.frame = self.redView.bounds
        av.view.backgroundColor = self.redView.backgroundColor
        self.redView.addSubview(av.view)
        av.didMove(toParent: self)
    }
    
    func tap (g:UIGestureRecognizer) {
        self.picker?.takePicture()
    }
    
    
}
