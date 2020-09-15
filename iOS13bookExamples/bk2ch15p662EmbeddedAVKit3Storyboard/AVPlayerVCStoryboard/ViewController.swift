

import UIKit
import AVKit

class ViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let avc = segue.destination as? AVPlayerViewController {
            let url = Bundle.main.url(forResource: "ElMirage", withExtension: "mp4")!
            let player = AVPlayer(url: url)
            avc.player = player
        }
    }

}

