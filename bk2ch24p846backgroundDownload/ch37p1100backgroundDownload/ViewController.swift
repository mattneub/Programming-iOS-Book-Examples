

import UIKit

class ViewController: UIViewController {

    @IBOutlet var iv : UIImageView!
    @IBOutlet var prog : UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(gotPicture), name: .gotPicture, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gotProgress), name: .gotProgress, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("%@", "view did appear")
        self.grabPicture()
    }
        
    @IBAction func doStart (_ sender: Any!) {
        self.prog.progress = 0
        self.iv.image = nil
        let del = UIApplication.shared.delegate as! AppDelegate
        del.startDownload(self)
    }
    
    func grabPicture () {
        NSLog("%@", "grabbing picture")
        let del = UIApplication.shared.delegate as! AppDelegate
        self.iv.image = del.image
        del.image = nil
        if self.iv.image != nil {
            self.prog.progress = 1
        }
    }
    
    func gotPicture (_ n : Notification) {
        self.grabPicture()
    }
    
    func gotProgress (_ n : Notification) {
        if let ui = n.userInfo {
            if let prog = ui["progress"] as? NSNumber {
                self.prog.progress = Float(prog.doubleValue)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func crash(_ sender: Any?) {
        fatalError("kaboom")
    }


}
