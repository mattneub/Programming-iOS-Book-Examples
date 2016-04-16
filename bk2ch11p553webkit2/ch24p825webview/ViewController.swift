

import UIKit

class ViewController: UIViewController {
    @IBAction func doButton (_ sender:AnyObject!) {
        let wvc = WebViewController()
        self.navigationController!.pushViewController(wvc, animated:true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Start"
        self.edgesForExtendedLayout = [] // none
    }

}


