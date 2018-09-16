

import UIKit

class ViewController: UIViewController {

    @IBAction func doButton(_ sender: Any) {
        // popover segue's popover doesn't point its arrow correctly
        // this is such a huge bug that it makes popover segues useless!
        // uncomment next two lines to see the difference
//        self.performSegue(withIdentifier: "pop", sender: sender)
//        return;
        let vc2 = self.storyboard!.instantiateViewController(withIdentifier: "vc2")
        vc2.modalPresentationStyle = .popover
        self.present(vc2, animated: true)
        if let pop = vc2.popoverPresentationController {
            if let v = sender as? UIView {
                pop.sourceView = v
                pop.sourceRect = v.bounds
            }
        }
    }
    
}

