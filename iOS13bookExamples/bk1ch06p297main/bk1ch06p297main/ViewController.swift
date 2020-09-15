

import UIKit
import Coolness
import AVFoundation

class ViewController: UIViewController {
    
    var player : AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        
        let d = Dog()
        d.bark()
        
        // demonstrate use of an asset catalog for miscellaneous resource
        // also demonstrate asset catalog "namespace"
        let theme = NSDataAsset(name: "music/theme")!
        self.player = try! AVAudioPlayer(data: theme.data)
        self.player.play()
    }

}
