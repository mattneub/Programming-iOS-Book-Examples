
import UIKit

class MyPickerView : UIPickerView {
    
    override func intrinsicContentSize() -> CGSize {
        return super.intrinsicContentSize()
        
        // no need for trickery or testing; in iOS 9 you can just set the height constraint
        print("intrinsic")
        var sz = super.intrinsicContentSize()
        let h : CGFloat = 140
        print("trying to set to \(h)")
        sz.height = h // but it only goes down to 162, maximum 180
        // sz.width = 250 // just proving this actually does something
        return sz
    }
    
}

class ViewController: UIViewController {
    @IBOutlet var picker : UIPickerView!
    var states : [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let f = NSBundle.mainBundle().pathForResource("states", ofType: "txt")!
        let s = try! String(contentsOfFile: f, encoding: NSUTF8StringEncoding)
        self.states = s.componentsSeparatedByString("\n")
    }
    
    override func viewDidLayoutSubviews() {
        print(self.picker.frame.height)
    }
    
}

extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 50
    }
    
    // bug: no views are reused
    // the labels are not leaking (they are deallocated in good order)...
    // but they are not being reused either
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int,
        forComponent component: Int, reusingView view: UIView?) -> UIView {
            let lab : UILabel
            if let label = view as? UILabel {
                lab = label
                print("reusing label")
            } else {
                lab = MyLabel()
                print("making new label")
            }
            lab.text = self.states[row]
            lab.backgroundColor = UIColor.clearColor()
            lab.sizeToFit()
            return lab
    }
}

class MyLabel : UILabel {
    deinit {
        print("farewell")
    }
}
