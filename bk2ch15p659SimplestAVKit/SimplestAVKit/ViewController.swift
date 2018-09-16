

import UIKit
import AVKit
import AVFoundation

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

extension UILayoutPriority {
    static func +(lhs: UILayoutPriority, rhs: Float) -> UILayoutPriority {
        let raw = lhs.rawValue + rhs
        return UILayoutPriority(rawValue:raw)
    }
}


class ViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
        
        // sheesh
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.barHideOnTapGestureRecognizer.isEnabled = false
        self.navigationController?.hidesBarsWhenVerticallyCompact = false
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
                // av.view.backgroundColor = .green
                // let iv = UIImageView(image:UIImage(named:"smiley")!)
                return;
                // new in iOS 11, content overlay view is sized to its contents
                // so if you want it to fill the view, you must constrain it to do so
                let iv = UIView()
                iv.backgroundColor = .white
                av.contentOverlayView!.addSubview(iv)
                let v = av.contentOverlayView!
                iv.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    iv.bottomAnchor.constraint(equalTo:v.bottomAnchor),
                    iv.topAnchor.constraint(equalTo:v.topAnchor),
                    iv.leadingAnchor.constraint(equalTo:v.leadingAnchor),
                    iv.trailingAnchor.constraint(equalTo:v.trailingAnchor),
//                    iv.widthAnchor.constraint(equalToConstant: 100),
//                    iv.heightAnchor.constraint(equalToConstant: 100),
                ])
                NSLayoutConstraint.activate([
                    v.bottomAnchor.constraint(equalTo:av.view.bottomAnchor),
                    v.topAnchor.constraint(equalTo:av.view.topAnchor),
                    v.leadingAnchor.constraint(equalTo:av.view.leadingAnchor),
                    v.trailingAnchor.constraint(equalTo:av.view.trailingAnchor),
                ])

            }

            av.delegate = self
            av.allowsPictureInPicturePlayback = true
            // av.updatesNowPlayingInfoCenter = true // that's the default
            delay(2) {
                print(av.contentOverlayView!.frame)
            }
        case 2:
            // hmmm... this works so poorly that I can't really recommend it
            // if edgesForExtendedLayout is not set, we see the position slider just peeping down;
            // if it is, we don't see it at all, and so important functionality is lost
            // moreover, no matter what I do, the resulting interface is very confusing for the user
            // so I'm going to cut discussion of this approach from the book
            // well, it doesn't seem so bad now, putting the discussion back in
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
            ch(true)
        }
    }

}

