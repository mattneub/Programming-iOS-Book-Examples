

import UIKit

class Pep: UIViewController {
    
    let boy : String
    @IBOutlet var name : UILabel!
    @IBOutlet var pic : UIImageView!
    
    @IBInspectable var boyName : String = "Manny"
    
    init(pepBoy boy:String) {
        self.boy = boy
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.boy = self.boyName
        super.init(coder: coder)
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
