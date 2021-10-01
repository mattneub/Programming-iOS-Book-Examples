

import UIKit

class ViewController: UIViewController {
    
    @objc func tap() {
        print("tap")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tap, and long press for menu
        let b1 : UIBarButtonItem = {
            let action1 = UIAction(title: "") { _ in
                print("tap!")
            }
            let action2 = UIAction(title: "Surprise") { _ in
                print("surprise!")
            }
            let menu = UIMenu(title: "", children: [action2])
            return UIBarButtonItem(title: "Long", primaryAction: action1, menu: menu)
        }()
        
        // tap for menu - because no primary action
        let b2 : UIBarButtonItem = {
            let action = UIAction(title: "Surprise") { _ in
                print("surprise!")
            }
            let menu = UIMenu(title: "", children: [action])
            return UIBarButtonItem(title: "Short", menu: menu)
        }()
        
        // like the first one, just done another way
        let b3 : UIBarButtonItem = {
            let action = UIAction(title: "Surprise") { _ in
                print("surprise!")
            }
            let menu = UIMenu(title: "", children: [action])
            let b = UIBarButtonItem(title: "Long", style: .plain, target: self, action: #selector(tap))
            b.menu = menu
            return b
        }()
        
        // like the second one, just done another way
        let b4 : UIBarButtonItem = {
            let action = UIAction(title: "Surprise") { _ in
                print("surprise!")
            }
            let menu = UIMenu(title: "", children: [action])
            let b = UIBarButtonItem(title: "Short", style: .plain, target: nil, action: nil)
            b.menu = menu
            return b
        }()
        
        self.navigationItem.rightBarButtonItems = [b1, b2, b3, b4]
        
    }


}

