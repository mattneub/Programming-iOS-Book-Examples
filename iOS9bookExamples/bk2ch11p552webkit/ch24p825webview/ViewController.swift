

import UIKit

class ViewController: UIViewController {
    @IBAction func doButton (sender:AnyObject!) {
        let wvc = WebViewController()
        self.navigationController!.pushViewController(wvc, animated:true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Start"
        self.edgesForExtendedLayout = .None
    }

}


