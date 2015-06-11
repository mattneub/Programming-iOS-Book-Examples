

import UIKit

class Pep: UIViewController {
    
    var boy : String // * now assignable, we will assign on decode
    @IBOutlet var name : UILabel!
    @IBOutlet var pic : UIImageView!
    
    // we add "required" to satisfy the compiler's worry that class's "self" might be a subclass
    required init(pepBoy boy:String) {
        self.boy = boy
        super.init(nibName: "Pep", bundle: nil)
        self.restorationIdentifier = "pep" // *
        // self.restorationClass = self.dynamicType // * no restoration class, let app delegate point
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        // super.encodeRestorableStateWithCoder(coder)
        println("pep about to encode boy \(self.boy)")
        coder.encodeObject(self.boy, forKey:"boy")
    }
    
    // and now we simply decode directly
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        // super.decodeRestorableStateWithCoder(coder)
        let boy : AnyObject? = coder.decodeObjectForKey("boy")
        println("pep about to decode boy \(boy)")
        if let boy = boy as? String {
            self.boy = boy
        }
    }
    
    // one more step; in case we just did state restoration,
    // match interface to newly assigned boy
    // oops, not DRY: this is exactly the same as viewDidLoad()
    
    override func applicationFinishedRestoringState() {
        self.name.text = self.boy
        self.pic.image = UIImage(named:"\(self.boy.lowercaseString).jpg")
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

// and no UIViewControllerRestoration

