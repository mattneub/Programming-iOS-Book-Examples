

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.button.addTarget(self,
            action: #selector(buttonPressed),
            forControlEvents: .TouchUpInside)
        
        self.button2.addTarget(nil, // nil-targeted
            action: #selector(buttonPressed),
            forControlEvents: .TouchUpInside)

        // third button is configured as nil-targeted in nib

    }

    @IBAction func buttonPressed(sender:AnyObject) {
        let alert = UIAlertController(
            title: "Howdy!", message: "You tapped me!", preferredStyle: .Alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    // rewritten to avoid use of C-style for loop

    @IBAction func showResponderChain(sender: UIResponder) {
        var r : UIResponder! = sender
        repeat { print(r, "\n"); r = r.nextResponder() } while r != nil
    }

}

