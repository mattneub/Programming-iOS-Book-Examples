import UIKit

class MainViewController: UIViewController, FlipsideViewControllerDelegate {

    func flipsideViewControllerDidFinish(_ controller:FlipsideViewController) {
        self.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAlternate" {
            if let dest = segue.destination as? FlipsideViewController {
                dest.delegate = self
            }
        }
    }
    
    @IBAction func woohoo(_ sender : Any) {
        NotificationCenter.default.post(name: .woohoo, object: nil)
    }
    
}
