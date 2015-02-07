import UIKit

class MainViewController: UIViewController, FlipsideViewControllerDelegate {

    func flipsideViewControllerDidFinish(controller:FlipsideViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAlternate" {
            if let dest = segue.destinationViewController as? FlipsideViewController {
                dest.delegate = self
            }
        }
    }
    
}
