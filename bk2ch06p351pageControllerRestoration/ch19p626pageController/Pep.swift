

import UIKit

class Pep: UIViewController {
    
    let boy : String
    @IBOutlet var name : UILabel!
    @IBOutlet var pic : UIImageView!
    
    init(pepBoy boy:String, nib:String?, bundle:NSBundle?) {
        self.boy = boy
        super.init(nibName: nib, bundle: bundle)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.text = self.boy
        self.pic.image = UIImage(named:"\(self.boy.lowercaseString).jpg")
    }
    
    override var description : String {
    return self.boy
    }
    
    @IBAction func tap (sender: UIGestureRecognizer?) {
        NSNotificationCenter.defaultCenter().postNotificationName("tap", object: sender)
    }


}
