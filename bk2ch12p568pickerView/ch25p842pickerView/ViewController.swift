
import UIKit

class MyPickerView : UIPickerView {
    
    override func intrinsicContentSize() -> CGSize {
        println("intrinsic")
        var sz = super.intrinsicContentSize()
        sz.height = 140 // but it only goes down to 162, maximum 180
        // sz.width = 250 // just proving this actuall does something
        return sz
    }
    
}

class ViewController: UIViewController {
    @IBOutlet var picker : UIPickerView!
    var states : [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let f = NSBundle.mainBundle().pathForResource("states", ofType: "txt")
        let s = NSString(contentsOfFile: f, encoding: NSUTF8StringEncoding, error: nil)
        self.states = s.componentsSeparatedByString("\n") as [String]
    }
    
    override func viewDidLayoutSubviews() {
        println(self.picker.frame.height)
    }
    
}

extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return 50
    }
    
    func pickerView(pickerView: UIPickerView!, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView! {
        var lab : UILabel
        if (view) {
            lab = view as UILabel
        } else {
            lab = UILabel()
        }
        lab.text = self.states[row]
        lab.backgroundColor = UIColor.clearColor()
        lab.sizeToFit()
        return lab
    }
    


    
}
