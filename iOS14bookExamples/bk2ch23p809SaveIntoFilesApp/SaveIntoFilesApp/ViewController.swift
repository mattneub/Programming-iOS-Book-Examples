

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doButton (_ sender:Any) {
        if let del = UIApplication.shared.delegate as? AppDelegate {
            if let ubiq = del.ubiq {
                do {
                    let fm = FileManager.default
                    let docs = ubiq.appendingPathComponent("Documents")
                    try? fm.createDirectory(at: docs, withIntermediateDirectories: false, attributes: nil)
                    let url = docs.appendingPathComponent("test.txt")
                    print("here we go")
                    try? fm.removeItem(at: url)
                    try "howdy \(Date())".write(to: url, atomically: true, encoding: .utf8)
                    print("saved")
                    
                } catch {
                    print(error)
                }
            }
        }
    }



}

