

import UIKit

class ViewController: UIViewController {
    
    var player = Player()
    
    @IBAction func doButton (sender:AnyObject!) {
        let s = NSBundle.mainBundle().pathForResource("Hooded", ofType: "aiff")!
        self.player.playFileAtPath(s)
    }



}
