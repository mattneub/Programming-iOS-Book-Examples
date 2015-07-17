
import UIKit
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class SettingsController: UIViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
    }
    func navigationControllerSupportedInterfaceOrientations(
        nav: UINavigationController) -> UIInterfaceOrientationMask {
            return .Portrait
    }

    @IBAction func doButton(sender: AnyObject) {
        self.showColorPicker()
    }
}

extension SettingsController : ColorPickerDelegate {
    func showColorPicker() {
        let colorName = "MyColor"
        let c = UIColor.blueColor()
        let cpc = ColorPickerController(colorName:colorName, andColor:c)
        cpc.delegate = self
        self.presentViewController(cpc, animated: true, completion: nil)
    }
    
    // delegate method
    
    func colorPicker (picker:ColorPickerController,
        didSetColorNamed theName:String?,
        toColor theColor:UIColor?) {
            print("the delegate method was called")
            delay(0.1) {
                picker.dismissViewControllerAnimated(true, completion: nil)
            }
    }

}

