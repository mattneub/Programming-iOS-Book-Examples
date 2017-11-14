

import UIKit

class ViewController: UIViewController {

    @IBOutlet var iv : UIImageView!
    @IBOutlet var prog : UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(gotPicture), name: .gotPicture, object: nil)
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
        let progress = del.startDownload(self)
        self.prog.observedProgress = progress
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
    
    @objc func gotPicture (_ n : Notification) {
        self.grabPicture()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func crash(_ sender: Any?) {
        fatalError("kaboom")
    }


}
