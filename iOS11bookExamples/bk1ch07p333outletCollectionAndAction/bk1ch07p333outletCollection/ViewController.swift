

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var coolviews : [UIView]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (ix,b) in (self.coolviews as! [UIButton]).enumerated() {
            b.setTitle("B\(ix+1)", for:.normal)
        }
    }
    
    @IBAction func buttonPressed(_ sender: Any) { // underscore is crucial
        let alert = UIAlertController(
            title: "Howdy!", message: "You tapped me!", preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .cancel)) // can omit handler:
        self.present(alert, animated: true) // can omit completion:
    }



}

