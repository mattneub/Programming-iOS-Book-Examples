
import UIKit
import Photos
import PhotosUI // NB!

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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkForPhotoLibraryAccess {
            let recs = PHAssetCollection.fetchAssetCollections(with:
                .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
            guard let rec = recs.firstObject else {return}
            let options = PHFetchOptions()
            let pred = NSPredicate(format: "(mediaSubtype & %d) != 0", PHAssetMediaSubtype.photoLive.rawValue)
            options.predicate = pred
            options.fetchLimit = 1
            let photos = PHAsset.fetchAssets(in: rec, options: options)
            if photos.count > 0 {
                let photo = photos[0]
                let opts = PHLivePhotoRequestOptions()
                opts.deliveryMode = .highQualityFormat
                PHImageManager.default().requestLivePhoto(for: photo, targetSize: CGSize(300,300), contentMode: .aspectFit, options: opts) {
                    photo, info in
                    print(photo?.size as Any)
                    let v = PHLivePhotoView(frame: CGRect(20,20,300,300))
                    v.contentMode = .scaleAspectFit
                    v.livePhoto = photo
                    self.view.addSubview(v)
                }

            }

            
            
        }
    }


}

