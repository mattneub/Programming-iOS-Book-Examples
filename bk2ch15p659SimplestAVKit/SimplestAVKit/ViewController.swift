

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        _ = try? AVAudioSession.sharedInstance().setActive(true)
    }


    let which = 1
    
    @IBAction func doPresent(_ sender: AnyObject) {
        switch which {
        case 1:
            let av = AVPlayerViewController()
            let url = Bundle.main().urlForResource("ElMirage", withExtension: "mp4")!
            // let url = NSBundle.main().urlForResource("wilhelm", withExtension: "aiff")!
            let player = AVPlayer(url: url)
            av.player = player
            self.present(av, animated: true) {
                _ in
                // av.view.backgroundColor = UIColor.green()
            }
//            let iv = UIImageView(image:UIImage(named:"smiley")!)
//            av.contentOverlayView!.addSubview(iv)
//            let v = iv.superview!
//            iv.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                iv.bottomAnchor.constraint(equalTo:v.bottomAnchor),
//                iv.topAnchor.constraint(equalTo:v.topAnchor),
//                iv.leadingAnchor.constraint(equalTo:v.leadingAnchor),
//                iv.trailingAnchor.constraint(equalTo:v.trailingAnchor),
//                ])

            av.delegate = self
            av.allowsPictureInPicturePlayback = true
        case 2:
            let av = AVPlayerViewController()
            av.edgesForExtendedLayout = []
            let url = Bundle.main().urlForResource("ElMirage", withExtension: "mp4")!
            // let url = NSBundle.main().urlForResource("wilhelm", withExtension: "aiff")!
            let player = AVPlayer(url: url)
            av.player = player
            self.show(av, sender: self)
        default: break
        }
        
    }
}

extension ViewController : AVPlayerViewControllerDelegate {
    /*
    func playerViewControllerShouldAutomaticallyDismissAtPicture(inPictureStart playerViewController: AVPlayerViewController) -> Bool {
        return false
    }
 */
    
    func playerViewController(_ pvc: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler ch: (Bool) -> Void) {
        self.present(pvc, animated:true) {
            _ in
            ch(true)
        }
    }

}

