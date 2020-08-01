
import UIKit

class Pep: UIViewController {
    
    let boy : String
    @IBOutlet var name : UILabel!
    @IBOutlet var pic : UIImageView!
    
    override var nibName: String? { "Pep" }
    
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
    
    @IBAction func doShowHide(_ sender: Any) {
        self.showHide(self)
        // also looking to see whether split view controller can still respond to `show:sender:`
        let vc = UIViewController()
        vc.view.backgroundColor = .blue
        self.splitViewController?.show(vc, sender: self)
        // well, it didn't like that! it took it as "show compact column" and turned it into presentation
    }
    
    override var description : String {
        return self.boy
    }
    
    // =======
    
    override func targetViewController(forAction action: Selector, sender: Any?) -> UIViewController? {
        print(self, #function, action, "called")
        let result = super.targetViewController(forAction: action, sender: sender)
        print(self, #function, result as Any)
        return result
    }

}
