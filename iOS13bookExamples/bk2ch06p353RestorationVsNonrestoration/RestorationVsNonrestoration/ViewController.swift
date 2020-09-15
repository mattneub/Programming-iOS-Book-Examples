

import UIKit

class ViewController: UIViewController, UIViewControllerRestoration {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func doPresent(_ sender: Any) {
        let sheet = UIAlertController(title: "Pep", message: "Pick a Pep boy:", preferredStyle: .actionSheet)
        for boy in ["Manny", "Moe", "Jack"] {
            sheet.addAction(UIAlertAction(title:boy, style: .default) { _ in
                self.present(boy:boy)
            })
        }
        sheet.addAction(UIAlertAction(title:"Cancel", style: .cancel))
        self.present(sheet, animated:true)
    }
    
    func present(boy:String) {
        let vc2 = ViewController2()
        vc2.boy = boy
        vc2.restorationIdentifier = "vc2"
        vc2.restorationClass = type(of:self)
        self.present(vc2, animated: true)
    }
    
    static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        let vc2 = ViewController2()
        vc2.restorationIdentifier = "vc2"
        vc2.restorationClass = self
        return vc2
    }

}

