

import UIKit

class ViewController: UIViewController {

    @IBOutlet var iv : UIImageView!
    
    @IBAction func doSimpleHTTP (_ sender:AnyObject!) {
        self.iv.image = nil
        let s = "http://www.apeth.net/matt/images/phoenixnewest.jpg"
        let url = URL(string:s)!
        let session = URLSession.shared()
        let task = session.downloadTask(with:url) {
            (loc:URL?, response:URLResponse?, error:NSError?) in
            print("here")
            if error != nil {
                print(error)
                return
            }
            let status = (response as! HTTPURLResponse).statusCode
            print("response status: \(status)")
            if status != 200 {
                print("oh well")
                return
            }
            if let d = try? Data(contentsOf:loc!) {
                let im = UIImage(data:d)
                DispatchQueue.main.async {
                    self.iv.image = im
                    print("done")
                }
            }
        }
        task.resume()
    }
}
