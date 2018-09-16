

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.button.addTarget(self, // change self to self.button to crash
            action: #selector(buttonPressed),
            for: .touchUpInside)
        
        self.button2.addTarget(nil, // nil-targeted
            action: #selector(buttonPressed),
            for: .touchUpInside)

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
        repeat { print(r, "\n"); r = r.next } while r != nil
    }
    
    @IBAction func unwind(_ sender: UIStoryboardSegue) {}

}

