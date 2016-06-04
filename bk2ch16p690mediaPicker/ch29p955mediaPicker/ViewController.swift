

import UIKit
import MediaPlayer

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



class ViewController: UIViewController {
    
    @IBAction func doGo (_ sender:AnyObject!) {
        self.presentPicker(sender)
    }
    
    func presentPicker (_ sender:AnyObject) {
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

extension ViewController : MPMediaPickerControllerDelegate {
    // must implement these, as there is no automatic dismissal
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        print("did pick")
        let player = MPMusicPlayerController.applicationMusicPlayer()
        player.setQueueWith(mediaItemCollection)
        player.play()
        self.dismiss(animated:true)
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        print("cancel")
        self.dismiss(animated:true)
    }

}

extension ViewController : UIBarPositioningDelegate {
    func positionForBar(forBar bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
