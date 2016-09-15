

import UIKit

class ViewController: UIViewController {

    @IBOutlet var iv : UIImageView!
    
    @IBAction func doSimpleHTTP (sender:AnyObject!) {
        self.iv.image = nil
        let s = "http://www.apeth.net/matt/images/phoenixnewest.jpg"
        let url = NSURL(string:s)!
        let session = NSURLSession.sharedSession()
        let task = session.downloadTaskWithURL(url) {
            (loc:NSURL?, response:NSURLResponse?, error:NSError?) in
            print("here")
            if error != nil {
                print(error)
                return
            }
            let status = (response as! NSHTTPURLResponse).statusCode
            print("response status: \(status)")
            if status != 200 {
                print("oh well")
                return
            }
            let d = NSData(contentsOfURL:loc!)!
            let im = UIImage(data:d)
            dispatch_async(dispatch_get_main_queue()) {
                self.iv.image = im
                print("done")
            }
        }
        task.resume()
    }
}
