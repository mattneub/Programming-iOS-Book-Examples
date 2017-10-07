
import UIKit

class ViewController: UIViewController {
    @IBOutlet var picker : UIPickerView!
    var states : [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let f = Bundle.main.path(forResource: "states", ofType: "txt")!
        let s = try! String(contentsOfFile: f)
        self.states = s.components(separatedBy:"\n")
    }
    
    override func viewDidLayoutSubviews() {
        print(self.picker.frame.height)
    }
    
}

extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.states.count
    }
    
    // bug: no views are reused
    // the labels are not leaking (they are deallocated in good order)...
    // but they are not being reused either
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        let lab : UILabel
        if let label = view as? UILabel {
            lab = label
            print("reusing label")
        } else {
            lab = MyLabel()
            print("making new label")
        }
        lab.text = self.states[row]
        lab.backgroundColor = .clear
        lab.sizeToFit()
        return lab
    }
}

class MyLabel : UILabel {
    deinit {
        print("farewell")
    }
}
