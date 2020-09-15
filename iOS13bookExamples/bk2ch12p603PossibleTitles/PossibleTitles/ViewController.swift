
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let bbi = UIBarButtonItem(title: "Hey", style: .plain, target: nil, action: nil)
        // no effect:
        bbi.possibleTitles = ["Howdyhowdy", "Hey"]
        let bbi2 = UIBarButtonItem(title: "Ho", style: .plain, target: nil, action: nil)
        // also showing size constraints on custom view
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .red
        v.heightAnchor.constraint(equalToConstant:10).isActive = true
        v.widthAnchor.constraint(equalToConstant: 40).isActive = true
        let bbi3 = UIBarButtonItem(customView: v)
        self.navigationItem.rightBarButtonItems = [bbi, bbi2, bbi3]
        
    }



}

