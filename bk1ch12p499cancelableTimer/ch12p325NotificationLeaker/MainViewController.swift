import UIKit

class MainViewController: UIViewController, FlipsideViewControllerDelegate {

    func flipsideViewControllerDidFinish(_ controller:FlipsideViewController) {
        self.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAlternate" {
            if let dest = segue.destinationViewController as? FlipsideViewController {
                dest.delegate = self
            }
        }
    }
    
}
