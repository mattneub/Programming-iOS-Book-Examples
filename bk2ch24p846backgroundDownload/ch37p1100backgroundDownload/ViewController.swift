

import UIKit

class ViewController: UIViewController {

    @IBOutlet var iv : UIImageView!
    @IBOutlet var prog : UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotPicture:", name: "GotPicture", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotProgress:", name: "GotProgress", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("%@", "view did appear")
        self.grabPicture()
    }
        
    @IBAction func doStart (sender:AnyObject!) {
        self.prog.progress = 0
        self.iv.image = nil
        let del = UIApplication.sharedApplication().delegate as! AppDelegate
        del.startDownload(self)
    }
    
    func grabPicture () {
        NSLog("%@", "grabbing picture")
        let del = UIApplication.sharedApplication().delegate as! AppDelegate
        self.iv.image = del.image
        del.image = nil
        if self.iv.image != nil {
            self.prog.progress = 1
        }
    }
    
    func gotPicture (n : NSNotification) {
        self.grabPicture()
    }
    
    func gotProgress (n : NSNotification) {
        if let ui = n.userInfo {
            if let prog = ui["progress"] as? NSNumber {
                self.prog.progress = Float(prog.doubleValue)
            }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func crash (sender:AnyObject?) {
        _ = sender as! String
    }


}
