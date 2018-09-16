
import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
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

    @IBAction func doButton(_ sender: Any) {
        self.showColorPicker()
    }
}

extension SettingsController : ColorPickerDelegate {
    func showColorPicker() {
        let colorName = "MyColor"
        let c = UIColor.blue
        let cpc = ColorPickerController(colorName:colorName, color:c)
        cpc.delegate = self
        self.present(cpc, animated: true)
    }
    
    // delegate method
    
    func colorPicker (_ picker:ColorPickerController,
        didSetColorNamed theName:String?,
        to theColor:UIColor?) {
            print("the delegate method was called")
            delay(0.1) {
                picker.dismiss(animated: true)
            }
    }

}

