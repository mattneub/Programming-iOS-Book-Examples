

import UIKit

protocol ColorPickerDelegate : class {
    // color == nil on cancel
    func colorPicker (_ picker:ColorPickerController,
        didSetColorNamed theName:String?,
        to theColor:UIColor?)
}

class ColorPickerController : UIViewController {
    weak var delegate: ColorPickerDelegate?
    var color = UIColor.red
    var colorName : String
    
    init(colorName:String, color:UIColor) {
        self.colorName = colorName
        super.init(nibName: "ColorPicker", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }

    @IBAction func dismissColorPicker(_ sender: Any?) {
        let c : UIColor? = self.color
        self.delegate?.colorPicker(
            self, didSetColorNamed: self.colorName, to: c)
    }
}
