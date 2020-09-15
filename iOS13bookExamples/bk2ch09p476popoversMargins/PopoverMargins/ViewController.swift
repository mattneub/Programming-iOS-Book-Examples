

import UIKit

class VC2 : UIViewController {
    override func viewDidLoad() {
        self.view.backgroundColor = .green
        let v = UIView()
        v.backgroundColor = .red
        v.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(v)
        v.topAnchor.constraint(equalTo: self.view.topAnchor, constant:20).isActive = true
        v.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant:-20).isActive = true
        // let sup = self.view! // to show that edge is not where you think
        let sup = self.view.layoutMarginsGuide // looks centered
        v.leadingAnchor.constraint(equalTo: sup.leadingAnchor, constant:20).isActive = true
        v.trailingAnchor.constraint(equalTo: sup.trailingAnchor, constant:-20).isActive = true
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let vc = VC2()
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true)
        if let pop = vc.popoverPresentationController {
            pop.sourceView = self.view
            pop.sourceRect = CGRect(x: 10, y: 50, width: 20, height: 20)
        }
    }
    
}

