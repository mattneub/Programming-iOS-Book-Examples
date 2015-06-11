

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    
    @IBAction func doGo (sender:AnyObject!) {
        self.presentPicker(sender)
    }
    
    func presentPicker (sender:AnyObject) {
        // universal app is so incredibly easy in iOS 8!
        let picker = MPMediaPickerController(mediaTypes:.Music) // new in iOS 8, need to specify
        // for example, you can have just podcasts or audio books
        // I don't understand what the "video" options are for; when I try them, I get all audio
        picker.delegate = self
        picker.allowsPickingMultipleItems = true
        picker.modalPresentationStyle = .Popover
        picker.preferredContentSize = CGSizeMake(500,600)
        self.presentViewController(picker, animated: true, completion: nil)
        if let pop = picker.popoverPresentationController {
            if let b = sender as? UIBarButtonItem {
                pop.barButtonItem = b
            }
        }
    }
}

extension ViewController : MPMediaPickerControllerDelegate {
    // must implement these, as there is no automatic dismissal
    
    func mediaPicker(mediaPicker: MPMediaPickerController!, didPickMediaItems mediaItemCollection: MPMediaItemCollection!) {
        let player = MPMusicPlayerController.applicationMusicPlayer()
        player.setQueueWithItemCollection(mediaItemCollection)
        player.play()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

extension ViewController : UIBarPositioningDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}
