

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tf: UITextField!
    
    let which = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch which {
        case 1:
            let bbi = UIBarButtonItem(
                barButtonSystemItem: .Camera, target: self, action: "doCamera:")
            let group = UIBarButtonItemGroup(
                barButtonItems: [bbi], representativeItem: nil)
            let shortcuts = self.tf.inputAssistantItem
            shortcuts.trailingBarButtonGroups.append(group)

        case 2:
            var bbis = [UIBarButtonItem]()
            for _ in 1...5 {
                let bbi = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "doCamera:")
                bbis.append(bbi)
            }
            let rep = UIBarButtonItem(barButtonSystemItem: .Edit, target: nil, action: nil)
            let group = UIBarButtonItemGroup(barButtonItems: bbis, representativeItem: rep)
            let shortcuts = self.tf.inputAssistantItem
            shortcuts.trailingBarButtonGroups.append(group)

        default:break
        }
        

        
    }
    
    func doCamera(sender:AnyObject) {
        print("do camera")
    }
 


}

