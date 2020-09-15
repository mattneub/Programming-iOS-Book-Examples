

import UIKit
import Photos
import AVKit

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
    @unknown default: fatalError()
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var v: UIView!

    @IBAction func doShowMovie(_ sender: Any) {
        checkForPhotoLibraryAccess(andThen: self.fetchMovie)
    }
    
    func fetchMovie() {
        let opts = PHFetchOptions()
        opts.fetchLimit = 1
        let result = PHAsset.fetchAssets(with: .video, options: opts)
        guard let asset = result.firstObject else {return}
        PHImageManager.default().requestPlayerItem(forVideo: asset, options: nil) {
            item, info in
            print(item as Any)
            if let item = item {
                DispatchQueue.main.async {
                    self.display(item:item)
                }
            }
        }
    }
    
    func display(item:AVPlayerItem) {
        let player = AVPlayer(playerItem: item)
        let vc = AVPlayerViewController()
        vc.player = player
        vc.view.frame = self.v.bounds
        self.addChild(vc)
        self.v.addSubview(vc.view)
        vc.didMove(toParent: self)
    }

}

