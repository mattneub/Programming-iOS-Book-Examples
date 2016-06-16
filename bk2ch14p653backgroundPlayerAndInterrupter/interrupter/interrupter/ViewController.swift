

import UIKit

class ViewController: UIViewController {
    
    var player = Player()
    
    @IBAction func doButton (_ sender:AnyObject!) {
        let s = Bundle.main().pathForResource("Hooded", ofType: "aiff")!
        self.player.playFile(atPath:s)
    }



}
