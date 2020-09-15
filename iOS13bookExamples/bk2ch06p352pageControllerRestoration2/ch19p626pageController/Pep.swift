

import UIKit

class Pep: UIViewController {
    
    let boy : String
    @IBOutlet var name : UILabel!
    @IBOutlet var pic : UIImageView!
    
    // we add "required" to satisfy the compiler's worry that class's "self" might be a subclass
    required init(pepBoy boy:String) {
        self.boy = boy
        super.init(nibName: nil, bundle: nil)
        self.restorationIdentifier = "pep" // *
        self.restorationClass = type(of:self) // *
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with:coder)
        print("pep about to encode boy \(self.boy)")
        coder.encode(self.boy, forKey:"boy")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.text = self.boy
        self.pic.image = UIImage(named:self.boy.lowercased())
    }
    
    override var description : String {
    return self.boy
    }
    
}

extension Pep : UIViewControllerRestoration {
    class func viewController(withRestorationIdentifierPath ip: [String], coder: NSCoder) -> UIViewController? {
        if let boy = coder.decodeObject(of:NSString.self, forKey:"boy") {
            print("pep decoded boy \(boy)")
            return self.init(pepBoy: boy as String)
        } else {
            return nil
        }
    }
}
