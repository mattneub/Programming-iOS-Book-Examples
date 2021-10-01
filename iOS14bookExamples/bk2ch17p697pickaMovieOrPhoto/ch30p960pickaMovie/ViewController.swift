

import UIKit
import PhotosUI
import AVKit
import ImageIO

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
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
    
    @IBAction func doPick (_ sender: Any) {
        
        
        // new in iOS 14, we can get the asset _later_ so we don't need access up front
        do {
            // if you create the configuration with no photo library, you will not get asset identifiers
            var config = PHPickerConfiguration()
            // try it _with_ the library
            config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
            config.selectionLimit = 1 // default
            // what you filter out will indeed not appear in the picker
            config.filter = .livePhotos // default is all three appear, no filter
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            // works okay as a popover but even better just present, it will be a normal sheet
            self.present(picker, animated: true)
        }
        
    }
}

extension ViewController : PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) { // NB if you don't say this, it won't dismiss!
            print(Thread.isMainThread) // yep
            guard let result = results.first else { return }
            // proving you don't get asset id unless you specified library
            let assetid = result.assetIdentifier
            print(assetid as Any)
            // what did we get? I think the way to find out is to ask the provider
            let prov = result.itemProvider
            let types = prov.registeredTypeIdentifiers
            print("types:", types)
            // for image, "public.jpeg" or "public.png" etc
            // for video, "com.apple.quicktime-movie"
            // for live photo, ["com.apple.live-photo-bundle", "public.jpeg"]
            // for looping live photo, ["com.apple.private.auto-loop-gif", "com.apple.quicktime-movie", "com.compuserve.gif"]
            
            // NB UTType is new in iOS 14! where did they document this????
            if prov.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                self.dealWithVideo(result)
            } else if prov.canLoadObject(ofClass: PHLivePhoto.self) {
                self.dealWithLivePhoto(result)
            } else if prov.canLoadObject(ofClass: UIImage.self) {
                self.dealWithImage(result)
            }
        }
    }
    
    // deal with the different types
    // the result's itemProvider is ready to supply the data
    
    fileprivate func dealWithVideo(_ result: PHPickerResult) {
        // this is the hardest case
        // there is no class that represents "a movie"
        // plus, we don't want the movie in memory, we want a file on disk
        // so ask the provider to save the data for us
        let movie = UTType.movie.identifier // "com.apple.quicktime-movie"
        let prov = result.itemProvider
        // NB we could have a Progress here if we want one
        prov.loadFileRepresentation(forTypeIdentifier: movie) { url, err in
            if let url = url {
                // ok but there's a problem: the file wants to be deleted
                // so I use `main.sync` to pin it down long enough to configure the presentation
                DispatchQueue.main.sync {
                    // this type is private but I don't see how else to know it loops
                    let loopType = "com.apple.private.auto-loop-gif"
                    if prov.hasItemConformingToTypeIdentifier(loopType) {
                        print("looping movie")
                        self.showLoopingMovie(url: url)
                    } else {
                        print("normal movie")
                        self.showMovie(url: url)
                    }
                }
            }
        }
    }
    
    // the other cases are easy; just load the data as objects
    
    fileprivate func dealWithLivePhoto(_ result: PHPickerResult) {
        let prov = result.itemProvider
        prov.loadObject(ofClass: PHLivePhoto.self) { livePhoto, err in
            if let photo = livePhoto as? PHLivePhoto {
                DispatchQueue.main.async {
                    self.showLivePhoto(photo)
                }
            }
        }
    }
    
    fileprivate func dealWithImage(_ result: PHPickerResult) {
        let prov = result.itemProvider
        prov.loadObject(ofClass: UIImage.self) { im, err in
            if let im = im as? UIImage {
                DispatchQueue.main.async {
                    self.showImage(im)
                    // ??? but how do I pick up the image metadata
                    // well, the provider can provide the image data
                    self.fetchMetadata(prov)
                }
            }
        }
    }

    
    func clearAll() {
        print("clearing interface")
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
        print("showing image")
        self.clearAll()
        let iv = UIImageView(image:im)
        iv.contentMode = .scaleAspectFit
        iv.frame = self.redView.bounds
        self.redView.addSubview(iv)
    }
    
    func showMovie(url:URL) {
        self.clearAll()
        print("showing movie")
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
        print("showing loop")
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
    
    func fetchLivePhoto(from asset:PHAsset?) {
        // well then I'll fetch it myself, said the little red hen
        print("attempting to fetch live photo")
        if let asset = asset {
            let options = PHLivePhotoRequestOptions()
            options.deliveryMode = .highQualityFormat
            PHImageManager.default().requestLivePhoto(for: asset, targetSize: self.redView.bounds.size, contentMode: .aspectFit, options: options) { photo, info in
                print("got live photo")
                if let photo = photo {
                    self.showLivePhoto(photo)
                }
            }
        }
    }
    
    func showLivePhoto(_ ph:PHLivePhoto) {
        print("showing live photo")
        self.clearAll()
        let v = PHLivePhotoView(frame:self.redView.bounds)
        v.contentMode = .scaleAspectFit
        v.livePhoto = ph
        self.redView.addSubview(v)
    }
    
    func fetchMetadata(_ prov:NSItemProvider) {
        prov.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, err in
            if let data = data {
                let src = CGImageSourceCreateWithData(data as CFData, nil)!
                let d = CGImageSourceCopyPropertiesAtIndex(src,0,nil) as! [AnyHashable:Any]
                print("metadata", d)
            }
        }
    }
}
