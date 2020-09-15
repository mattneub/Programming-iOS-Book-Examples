
import UIKit

class ViewController: UIViewController, UIColorPickerViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        let well = UIColorWell(frame: CGRect(x: 100, y: 200, width: 50, height: 50))
        // well.backgroundColor = .black // just to see where it is
        well.addAction(UIAction { action in
            if let c = (action.sender as? UIColorWell)?.selectedColor {
                print(c)
            }
        }, for: .valueChanged)
        well.addAction(UIAction { action in print("here")}, for: .editingDidEnd) // nope
        well.title = "Pick a color:"
        well.sizeToFit()
        self.view.addSubview(well)
    }
    
    
    @IBAction func doButton(_ sender: Any) {
        let cp = UIColorPickerViewController()
        cp.title = "Hey ho"
        cp.delegate = self
        print(cp.supportsAlpha)
        cp.supportsAlpha = false
        // but if it's a popover there's no way to discern cancellation vs acceptance
//        cp.modalPresentationStyle = .popover
        self.present(cp, animated: true)
//        if let ppc = cp.popoverPresentationController {
//            let v = sender as! UIView
//            ppc.sourceView = v
//            ppc.sourceRect = v.bounds
//        }
        self.chosenColor = nil
    }
    var chosenColor: UIColor?
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        self.chosenColor = viewController.selectedColor
    }
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        print("finish")
        if let color = self.chosenColor {
            // use color here
            print(color)
        }
    }
}

