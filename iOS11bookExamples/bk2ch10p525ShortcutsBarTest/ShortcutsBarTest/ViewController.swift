

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tf: UITextField!
    
    let which = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // iPad only
        
        switch which {
        case 1:
            let bbi = UIBarButtonItem(
                barButtonSystemItem: .camera, target: self, action: #selector(doCamera))
            let group = UIBarButtonItemGroup(
                barButtonItems: [bbi], representativeItem: nil)
            let shortcuts = self.tf.inputAssistantItem
            shortcuts.trailingBarButtonGroups.append(group)

        case 2:
            var bbis = [UIBarButtonItem]()
            for _ in 1...5 {
                let bbi = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(doCamera))
                bbis.append(bbi)
            }
            let rep = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: nil)
            let group = UIBarButtonItemGroup(barButtonItems: bbis, representativeItem: rep)
            let shortcuts = self.tf.inputAssistantItem
            shortcuts.trailingBarButtonGroups.append(group)

        default:break
        }
        

        
    }
    
    @objc func doCamera(_ sender: Any) {
        print("do camera")
    }
 


}

