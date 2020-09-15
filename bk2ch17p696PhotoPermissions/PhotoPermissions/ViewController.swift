
import UIKit
import Photos

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // choices in Settings are Add Photos Only, Selected Photos, All Photos, None
    
    // All Photos gives `.authorized` for both
    // None gives `.denied` for both
    // Selected Photos gives `.denied` for `.addOnly` if it hasn't been explicitly allowed already
    // So it's confusing: if user chooses Add Photos Only and then immediately Selected Photos, result is authorized for add but limited for readwrite, I think this is a failed user interface even though the results are clear enough for us

    @IBAction func doButton1(_ sender: Any) {
        // Don't Allow and OK
        // will be `.limited` if full access is `.limited`
        // will be `.authorized` is full access is `.authorized`
        // but an attempt to add will work even if `.limited`!
        // NB can be `.authorized` even if full access is `.denied`
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            switch status {
            case .notDetermined:
                print("not determined")
            case .restricted:
                print("restricted")
            case .denied:
                print("denied")
            case .authorized:
                print("authorized")
            case .limited:
                print("limited")
            @unknown default:
                break
            }
        }
    }
    @IBAction func doButton2(_ sender: Any) {
        // Select Photos, Allow Access to All Photos, Don't Allow
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .notDetermined:
                print("not determined")
            case .restricted:
                print("restricted")
            case .denied:
                print("denied")
            case .authorized:
                print("authorized")
            case .limited:
                print("limited")
            @unknown default:
                break
            }
        }
    }
    @IBAction func tryToAdd (_ sender:Any) {
        let im = UIImage(named:"kittensFive.jpg")
        PHPhotoLibrary.shared().performChanges {
            let req = PHAssetCreationRequest.forAsset()
            req.addResource(with: .photo, data: im!.jpegData(compressionQuality: 1)!, options: nil)
        } completionHandler: { success, err in
            print(success)
        }

    }

}

