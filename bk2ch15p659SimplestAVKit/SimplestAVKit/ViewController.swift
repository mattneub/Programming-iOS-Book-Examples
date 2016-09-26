

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try? AVAudioSession.sharedInstance().setActive(true)
        
        // sheesh
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.barHideOnTapGestureRecognizer.isEnabled = false
    }


    let which = 1
    
    @IBAction func doPresent(_ sender: Any) {
        switch which {
        case 1:
            let av = AVPlayerViewController()
            let url = Bundle.main.url(forResource:"ElMirage", withExtension: "mp4")!
            // let url = Bundle.main.url(forResource:"wilhelm", withExtension: "aiff")!
            let player = AVPlayer(url: url)
            av.player = player
            self.present(av, animated: true) {
                _ in
                // av.view.backgroundColor = .green
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
            av.updatesNowPlayingInfoCenter = true // what does this do?
        case 2:
            // hmmm... this works so poorly that I can't really recommend it
            // if edgesForExtendedLayout is not set, we see the position slider just peeping down;
            // if it is, we don't see it at all, and so important functionality is lost
            // moreover, no matter what I do, the resulting interface is very confusing for the user
            // so I'm going to cut discussion of this approach from the book
            let av = AVPlayerViewController()
            av.edgesForExtendedLayout = []
            self.navigationController?.navigationBar.isTranslucent = false
            let url = Bundle.main.url(forResource:"ElMirage", withExtension: "mp4")!
            // let url = Bundle.main.url(forResource:"wilhelm", withExtension: "aiff")!
            let player = AVPlayer(url: url)
            av.player = player
            av.view.backgroundColor = .green
            self.show(av, sender: self)
        default: break
        }
        
    }
}

extension ViewController : AVPlayerViewControllerDelegate {
    
//    func playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart(_ playerViewController: AVPlayerViewController) -> Bool {
//        return false
//    }
    
    
    func playerViewController(_ pvc: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler ch: @escaping (Bool) -> Void) {
        self.present(pvc, animated:true) {
            _ in
            ch(true)
        }
    }

}

