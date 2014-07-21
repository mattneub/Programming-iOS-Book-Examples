

import UIKit

class Pep: UIViewController {
    
    let boy : String
    @IBOutlet var name : UILabel
    @IBOutlet var pic : UIImageView
    
    // we add @required to satisfy the compiler's worry that class's "self" might be a subclass
    @required init(pepBoy boy:String, nib:String?, bundle:NSBundle?) {
        self.boy = boy
        super.init(nibName: nib, bundle: bundle)
        self.restorationIdentifier = "pep" // *
        self.restorationClass = self.dynamicType // *
    }
    
    override func encodeRestorableStateWithCoder(coder: NSCoder!) {
        super.encodeRestorableStateWithCoder(coder)
        println("pep about to encode boy \(self.boy)")
        coder.encodeObject(self.boy, forKey:"boy")
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

extension Pep : UIViewControllerRestoration {
    class func viewControllerWithRestorationIdentifierPath(ip: [AnyObject]!, coder: NSCoder!) -> UIViewController! {
        let boy = coder.decodeObjectForKey("boy") as String
        println("pep decoded boy \(boy)")
        return self(pepBoy: boy, nib: nil, bundle: nil)
    }
}
