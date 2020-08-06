
import UIKit

class ViewController: UIViewController, UIColorPickerViewControllerDelegate {
    @IBAction func doButton(_ sender: Any) {
        let cp = UIColorPickerViewController()
        cp.delegate = self
        print(cp.supportsAlpha)
        cp.supportsAlpha = false
        self.present(cp, animated: true)
    }
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        print(color)
    }
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        print("finish")
    }
}

