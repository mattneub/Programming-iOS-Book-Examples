
import UIKit

class OnePepBoyViewController: UIViewController {
    
    let boy : String
    @IBOutlet var name : UILabel!
    @IBOutlet var pic : UIImageView!
        
    init(pepBoy boy:String = "Manny") {
        self.boy = boy
        super.init(nibName: nil, bundle: nil)
    }
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.text = self.boy
        self.pic.image = UIImage(named:self.boy.lowercased())
//        let bbi = UIBarButtonItem(
//            image: UIImage(systemName: "paperclip"),
//            primaryAction: UIAction(title: "") {
//                _ in print("does nothing")
//            }
//        )
//        self.navigationItem.rightBarButtonItem = bbi
    }
    
    override var description : String {
        return self.boy
    }
}
