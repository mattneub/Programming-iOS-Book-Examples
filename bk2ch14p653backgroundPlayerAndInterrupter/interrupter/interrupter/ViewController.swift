

import UIKit

class ViewController: UIViewController {
    
    var player = Player()
    
    @IBAction func doButton (_ sender: Any!) {
        let s = Bundle.main.pathForResource("Hooded", ofType: "aiff")!
        self.player.playFile(atPath:s)
    }



}
