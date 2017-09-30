
extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tf.delegate = self
        
//        let p = UIPickerView()
//        p.delegate = self
//        p.dataSource = self
//
//        self.tf.inputView = p
//        //
//        let b = UIButton(type: .system)
//        b.setTitle("Done", for: .normal)
//        b.sizeToFit()
//        b.addTarget(self, action: #selector(doDone), for: .touchUpInside)
//        b.backgroundColor = .lightGray
//        self.tf.inputAccessoryView = b
    }
    
    @objc func doDone() {
        self.tf.resignFirstResponder()
    }
}

extension ViewController: UITextFieldDelegate {
    // this way works fine too
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let p = UIPickerView()
        p.delegate = self
        p.dataSource = self
        
        // self.tf.inputView = p
        
        // or, better perhaps:
        
        let iv = UIInputView(frame: CGRect(origin:.zero, size:CGSize(200,200)), inputViewStyle: .keyboard)
        iv.addSubview(p)
        p.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            p.leadingAnchor.constraint(equalTo: iv.leadingAnchor),
            p.trailingAnchor.constraint(equalTo: iv.trailingAnchor),
            p.centerYAnchor.constraint(equalTo: iv.centerYAnchor)
        ])
        self.tf.inputView = iv

        let b = UIButton(type: .system)
        b.setTitle("Done", for: .normal)
        b.sizeToFit()
        b.addTarget(self, action: #selector(doDone), for: .touchUpInside)
        b.backgroundColor = UIColor.lightGray
        self.tf.inputAccessoryView = b

    }
}

extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    var pep : [String] {return ["Manny", "Moe", "Jack"]}
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pep.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pep[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.tf.text = self.pep[row]
    }

}

