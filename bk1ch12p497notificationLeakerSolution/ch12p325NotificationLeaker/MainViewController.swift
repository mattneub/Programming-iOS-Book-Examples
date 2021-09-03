import UIKit

extension Task where Success == Never, Failure == Never {
    static func sleep(_ seconds:Double) async {
        await self.sleep(UInt64(seconds * 1_000_000_000))
    }
    static func sleepThrowing(_ seconds:Double) async throws {
        try await self.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}


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
        Task {
            await Task.sleep(2.0)
            NotificationCenter.default.post(name: .woohoo, object: nil)
        }
    }
    
}
