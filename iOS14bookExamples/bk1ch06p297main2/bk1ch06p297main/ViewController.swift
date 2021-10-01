

import UIKit
import Coolness

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        
        let d = Dog()
        d.bark()
        
    }
}
