

import UIKit

class NilTargetedButton : UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        class Dummy {
            @objc func buttonPressed(_:Any) {}
        }
        self.addTarget(nil, // nil-targeted
            action: #selector(Dummy.buttonPressed),
            for: .touchUpInside)
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.button.addTarget(self, // change self to self.button to crash
            action: #selector(buttonPressed),
            for: .touchUpInside)
        
        // second button is configured as nil-targeted in class

        // third button is configured as nil-targeted in nib

    }

    @IBAction func buttonPressed(_ sender: Any) {
        let alert = UIAlertController(
            title: "Howdy!", message: "You tapped me!", preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }

    // rewritten to avoid use of C-style for loop

    @IBAction func showResponderChain(_ sender: UIResponder) {
        var r : UIResponder! = sender
        repeat { print(r as Any, "\n"); r = r.next } while r != nil
    }
    
    @IBAction func unwind(_ sender: UIStoryboardSegue) {}

}

