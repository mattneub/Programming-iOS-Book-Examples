
import UIKit

class MustacheViewController: UIViewController {

    weak var activity : UIActivity?
    var items: [Any]

    init(activity:UIActivity, items:[Any]) {
        self.activity = activity
        self.items = items
        super.init(nibName: "MustacheViewController", bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    @IBAction func doCancel(_ sender: Any) {
        self.activity?.activityDidFinish(false)
    }
    
    @IBAction func doDone(_ sender: Any) {
        self.activity?.activityDidFinish(true)
    }
    
    deinit{
        print("elaborate view controller dealloc")
    }

}
