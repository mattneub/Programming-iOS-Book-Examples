

import UIKit

class ViewController: UIViewController {
    
    var player = Player()
    
    @IBAction func doButton (sender:AnyObject!) {
        let s = NSBundle.mainBundle().pathForResource("Hooded", ofType: "mp3")
        self.player.playFileAtPath(s)
    }



}
