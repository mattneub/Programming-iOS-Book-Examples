

import UIKit
import MediaPlayer

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
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

func checkForMusicLibraryAccess(andThen f:(()->())? = nil) {
    let status = MPMediaLibrary.authorizationStatus()
    switch status {
    case .authorized:
        f?()
    case .notDetermined:
        MPMediaLibrary.requestAuthorization() { status in
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
    
    @IBAction func doGo (_ sender: Any!) {
        self.presentPicker(sender)
    }
    
    func presentPicker (_ sender: Any) {
        checkForMusicLibraryAccess {
            let picker = MPMediaPickerController(mediaTypes:.music)
            picker.showsCloudItems = false
            picker.delegate = self
            picker.allowsPickingMultipleItems = true
            picker.modalPresentationStyle = .popover
            picker.preferredContentSize = CGSize(500,600)
            self.present(picker, animated: true)
            if let pop = picker.popoverPresentationController {
                if let b = sender as? UIBarButtonItem {
                    pop.barButtonItem = b
                }
            }
        }
    }
}

extension ViewController : MPMediaPickerControllerDelegate {
    // must implement these, as there is no automatic dismissal
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        print("did pick")
        let player = MPMusicPlayerController.applicationMusicPlayer
        player.stop()
        player.setQueue(with:mediaItemCollection)
        delay(0.2) {
            player.play()
        }
        self.dismiss(animated:true)
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        print("cancel")
        self.dismiss(animated:true)
    }

}

extension ViewController : UIBarPositioningDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
