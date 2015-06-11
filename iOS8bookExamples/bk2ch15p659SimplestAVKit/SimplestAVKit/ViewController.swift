

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {

    @IBAction func doPresent(sender: AnyObject) {
        
        let which = 2
        switch which {
        case 1:
            let av = AVPlayerViewController()
            let url = NSBundle.mainBundle().URLForResource("ElMirage", withExtension: "mp4")
            // let url = NSBundle.mainBundle().URLForResource("wilhelm", withExtension: "aiff")
            let player = AVPlayer(URL: url)
            av.player = player
            self.presentViewController(av, animated: true, completion: {
                _ in
                // av.view.backgroundColor = UIColor.greenColor()
            })
        case 2:
            let av = AVPlayerViewController()
            av.edgesForExtendedLayout = .None
            let url = NSBundle.mainBundle().URLForResource("ElMirage", withExtension: "mp4")
            // let url = NSBundle.mainBundle().URLForResource("wilhelm", withExtension: "aiff")
            let player = AVPlayer(URL: url)
            av.player = player
            self.showViewController(av, sender: self)
        default: break
        }
        
    }
    


}

