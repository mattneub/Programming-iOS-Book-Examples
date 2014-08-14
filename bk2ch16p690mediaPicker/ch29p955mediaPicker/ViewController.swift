

import UIKit
import MediaPlayer

// not fully tested on iPad yet

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
        picker.modalPresentationStyle = .Popover // or comment this out for fullscreen on both
        self.presentViewController(picker, animated: true, completion: nil)
        if let pop = picker.popoverPresentationController {
            if pop.adaptivePresentationStyle() == .Popover {
                pop.barButtonItem = sender as UIBarButtonItem
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
    func positionForBar(bar: UIBarPositioning!) -> UIBarPosition {
        return .TopAttached
    }
}
