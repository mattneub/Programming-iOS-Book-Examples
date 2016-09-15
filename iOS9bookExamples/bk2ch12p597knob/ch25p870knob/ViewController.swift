
import UIKit

class ViewController: UIViewController {
    @IBOutlet var knob : MyKnob!
    
    @IBAction func doKnob (sender:AnyObject!) {
        let knob = sender as! MyKnob
        print("knob angle is \(knob.angle)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // uncomment to see the difference
        // self.knob.continuous = true

    }
    

}