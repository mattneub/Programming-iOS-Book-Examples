
import UIKit

class PepCompact: UIViewController {
    
    let boy : String
    @IBOutlet var name : UILabel!
    @IBOutlet var pic : UIImageView!
    
    override var nibName: String? { "Pep" } // use same nib
    
    init(pepBoy boy:String) {
        self.boy = boy
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        self.init(pepBoy: "Manny")
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.text = self.boy
        self.pic.image = UIImage(named:self.boy.lowercased())
        let bbi = UIBarButtonItem(
            image: UIImage(systemName: "paperclip"),
            primaryAction: UIAction(title: "") {
                _ in print("does nothing")
            }
        )
        self.navigationItem.rightBarButtonItem = bbi
    }
    
    override var description : String {
        return self.boy
    }
}
