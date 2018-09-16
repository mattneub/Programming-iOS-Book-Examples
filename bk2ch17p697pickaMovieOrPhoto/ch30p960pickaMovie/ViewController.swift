

import UIKit
import MobileCoreServices
import Photos
import PhotosUI
import AVKit
import ImageIO

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
    var looper : AVPlayerLooper!
    
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
        
        // according to the video, in iOS 11 no authorization is required,
        // because everything is happening out-of-process
        // but they haven't stated this accurately;
        // it works to get the photo, but if you want important stuff like the PHAsset and the media URL,
        // you still need authorization
        
        checkForPhotoLibraryAccess {
        
            // horrible Moments interface
            let src = UIImagePickerController.SourceType.savedPhotosAlbum
            // let src = UIImagePickerController.SourceType.photoLibrary
            guard UIImagePickerController.isSourceTypeAvailable(src)
                else { print("alas"); return }
            guard let arr = UIImagePickerController.availableMediaTypes(for:src)
                else { print("no available types"); return }
            let picker = UIImagePickerController()
            picker.sourceType = src
            // if you don't explicitly include live photos, you won't get any live photos as live photos
            picker.mediaTypes = [kUTTypeLivePhoto as String, kUTTypeImage as String, kUTTypeMovie as String]
            // picker.mediaTypes = arr
            print(arr)
            picker.delegate = self
            
            // new in iOS 11
            picker.videoExportPreset = AVAssetExportPreset640x480 // for example
            
            picker.allowsEditing = false // try true
            
            // this will automatically be fullscreen on phone and pad, looks fine
            // note that for .photoLibrary, iPhone app must permit portrait orientation
            // if we want a popover, on pad, we can do that; just uncomment next line
            picker.modalPresentationStyle = .popover
            self.present(picker, animated: true)
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
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { //
        let asset = info[.phAsset] as? PHAsset
        print(asset as Any)
        print(asset?.playbackStyle.rawValue as Any)
        // types are 0 for unsupported, then image, imageAnimated, livePhoto, video, videoLooping
        let url = info[.mediaURL] as? URL
        print("media url:", url as Any)
        var im = info[.originalImage] as? UIImage
        if let ed = info[.editedImage] as? UIImage {
            im = ed
        }
        let live = info[.livePhoto] as? PHLivePhoto
        let imurl = info[.imageURL] as? URL
        self.dismiss(animated:true) {
            if let style = asset?.playbackStyle {
                switch style {
                case .image:
                    if im != nil {
                        self.showImage(im!)
                    }
                    // how to pick up metadata
                    if imurl != nil {
                        self.pickUpMetadata(imurl!)
                    }
                case .imageAnimated:
                    if imurl != nil {
                        self.showAnimatedImage(imurl!)
                    }
                case .livePhoto:
                    if live != nil {
                        self.showLivePhoto(live!)
                    }
                case .video:
                    if url != nil {
                        self.showMovie(url:url!)
                    }
                case .videoLooping:
                    if url != nil {
                        self.showLoopingMovie(url:url!)
                    }
                case .unsupported: break
                }
            }
            // old code from when only three types of result were possible
            /*
            if let mediatype = info[UIImagePickerControllerMediaType],
                let type = mediatype as? NSString {
                switch type as CFString {
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
 */
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
    
    func showAnimatedImage(_ imurl:URL?) {
        guard let data = try? Data(contentsOf: imurl!) else { return }
        guard let anim = AnimatedImage(data: data) else { return }
        let arr = (0..<anim.frameCount).map { anim.image(at:$0)! }
        let iv = UIImageView()
        iv.animationImages = arr.map {UIImage(cgImage:$0)}
        iv.animationDuration = anim.duration
        iv.contentMode = .scaleAspectFit
        iv.frame = self.redView.bounds
        self.redView.addSubview(iv)
        iv.startAnimating()
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
        self.addChild(av)
        av.view.frame = self.redView.bounds
        av.view.backgroundColor = self.redView.backgroundColor
        self.redView.addSubview(av.view)
        av.didMove(toParent: self)
        player.play()
    }
    
    func showLoopingMovie(url:URL) {
        self.clearAll()
        let av = AVPlayerViewController()
        let player = AVQueuePlayer(url:url)
        av.player = player
        self.looper = AVPlayerLooper(player: player, templateItem: player.currentItem!)
        self.addChild(av)
        av.view.frame = self.redView.bounds
        av.view.backgroundColor = self.redView.backgroundColor
        self.redView.addSubview(av.view)
        av.didMove(toParent: self)
        player.play()
    }
    
    func showLivePhoto(_ ph:PHLivePhoto) {
        self.clearAll()
        let v = PHLivePhotoView(frame:self.redView.bounds)
        v.contentMode = .scaleAspectFit
        v.livePhoto = ph
        self.redView.addSubview(v)
    }
    
    func pickUpMetadata(_ imurl:URL?) {
        let src = CGImageSourceCreateWithURL(imurl! as CFURL, nil)!
        let d = CGImageSourceCopyPropertiesAtIndex(src,0,nil) as! [AnyHashable:Any]
        print(d)

    }
    
}
