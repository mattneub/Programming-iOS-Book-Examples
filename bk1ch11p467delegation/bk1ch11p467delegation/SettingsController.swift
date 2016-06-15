
import UIKit

func delay(_ delay:Double, closure:()->()) {
    let when = DispatchTime.now()
        + Double(Int64(delay * Double(NSEC_PER_SEC)))
        / Double(NSEC_PER_SEC)
    DispatchQueue.main.after(when: when, execute: closure)
}


class SettingsController: UIViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
    }
    func navigationControllerSupportedInterfaceOrientations(
        _ nav: UINavigationController) -> UIInterfaceOrientationMask {
            return .portrait
    }

    @IBAction func doButton(_ sender: AnyObject) {
        self.showColorPicker()
    }
}

extension SettingsController : ColorPickerDelegate {
    func showColorPicker() {
        let colorName = "MyColor"
        let c = UIColor.blue()
        let cpc = ColorPickerController(colorName:colorName, andColor:c)
        cpc.delegate = self
        self.present(cpc, animated: true)
    }
    
    // delegate method
    
    func colorPicker (_ picker:ColorPickerController,
        didSetColorNamed theName:String?,
        toColor theColor:UIColor?) {
            print("the delegate method was called")
            delay(0.1) {
                picker.dismiss(animated: true)
            }
    }

}

