

import UIKit

class NewGameController: UIViewController {

}

extension NewGameController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView,
        numberOfRowsInComponent component: Int) -> Int {
            return 9
    }
    func pickerView(pickerView: UIPickerView,
        titleForRow row: Int, forComponent component: Int) -> String? {
            return "\(row+1) Stage" + ( row > 0 ? "s" : "")
    }
}


