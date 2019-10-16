

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

/*
 Simple clear proof that an observer object
 
 (1) Doesn't need to be retained explicitly in order for the notification to be received
 
 (2) Lives on (leaks and is live) if you don't unregister it
 
 Present and go back. Then post notification. It is received, even though
 we never retained the observer.
 */

class ViewController: UIViewController {
    @IBAction func doPostWithDelay(_ sender: Any) {
        print("posting in 3 seconds")
        delay(3) {
            print("posting")
            NotificationCenter.default.post(name: ViewController2.notif, object: self)
        }
    }
    

    @IBAction func unwind (_ sender:UIStoryboardSegue) {
        
    }

}

