

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: [])
        _ = try? AVAudioSession.sharedInstance().setActive(true, withOptions: [])
    }


    let which = 1
    
    @IBAction func doPresent(sender: AnyObject) {
        switch which {
        case 1:
            let av = AVPlayerViewController()
            let url = NSBundle.mainBundle().URLForResource("ElMirage", withExtension: "mp4")!
            // let url = NSBundle.mainBundle().URLForResource("wilhelm", withExtension: "aiff")!
            let player = AVPlayer(URL: url)
            av.player = player
            self.presentViewController(av, animated: true, completion: {
                _ in
                // av.view.backgroundColor = UIColor.greenColor()
            })
//            let iv = UIImageView(image:UIImage(named:"smiley")!)
//            av.contentOverlayView!.addSubview(iv)
//            let v = iv.superview!
//            iv.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activateConstraints([
//                iv.bottomAnchor.constraintEqualToAnchor(v.bottomAnchor),
//                iv.topAnchor.constraintEqualToAnchor(v.topAnchor),
//                iv.leadingAnchor.constraintEqualToAnchor(v.leadingAnchor),
//                iv.trailingAnchor.constraintEqualToAnchor(v.trailingAnchor),
//                ])

            av.delegate = self
            av.allowsPictureInPicturePlayback = true
        case 2:
            let av = AVPlayerViewController()
            av.edgesForExtendedLayout = .None
            let url = NSBundle.mainBundle().URLForResource("ElMirage", withExtension: "mp4")!
            // let url = NSBundle.mainBundle().URLForResource("wilhelm", withExtension: "aiff")!
            let player = AVPlayer(URL: url)
            av.player = player
            self.showViewController(av, sender: self)
        default: break
        }
        
    }
}

extension ViewController : AVPlayerViewControllerDelegate {
    func playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStartNOT(playerViewController: AVPlayerViewController) -> Bool {
        return false
    }
    
    func playerViewController(pvc: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler ch: (Bool) -> Void) {
        self.presentViewController(pvc, animated:true) {
            _ in
            ch(true)
        }
    }

}

