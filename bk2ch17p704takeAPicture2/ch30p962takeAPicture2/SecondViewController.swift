

import UIKit

class SecondViewController: UIViewController {

    var image : UIImage!
    @IBOutlet var iv : UIImageView!
    
    init(image im:UIImage!) {
        self.image = im
        super.init(nibName: "SecondViewController", bundle: nil)
        self.title = "Decide"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Use", style: .Plain, target: self, action: "doUse:")
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.iv.image = self.image
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func doUse(sender:AnyObject) {
        let vc = self.presentingViewController as! ViewController
        vc.doUse(self.image)
    }
}
