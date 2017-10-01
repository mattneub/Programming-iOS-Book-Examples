
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

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


import UIKit

class MyDoneButtonViewController : UIInputViewController {
    weak var delegate : UIViewController?
    override func viewDidLoad() {
        
        let iv = self.inputView!
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.allowsSelfSizing = true // crucial

        let b = UIButton(type: .system)
        b.tintColor = .black
        b.setTitle("Done", for: .normal)
        b.sizeToFit()
        b.addTarget(self, action: #selector(doDone), for: .touchUpInside)
        b.backgroundColor = UIColor.lightGray
        iv.addSubview(b)
        b.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            b.topAnchor.constraint(equalTo: iv.topAnchor),
            b.bottomAnchor.constraint(equalTo: iv.bottomAnchor),
            b.leadingAnchor.constraint(equalTo: iv.leadingAnchor),
            b.trailingAnchor.constraint(equalTo: iv.trailingAnchor),
        ])

        
    }
    
    @objc func doDone() {
        self.delegate?.view?.endEditing(false)
    }


}

class MyPickerViewController : UIInputViewController {
    override func viewDidLoad() {
        
        let iv = self.inputView!
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        let p = UIPickerView()
        p.delegate = self
        p.dataSource = self
        iv.addSubview(p)
        p.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            p.topAnchor.constraint(equalTo: iv.topAnchor),
            p.bottomAnchor.constraint(equalTo: iv.bottomAnchor),
            p.leadingAnchor.constraint(equalTo: iv.leadingAnchor),
            p.trailingAnchor.constraint(equalTo: iv.trailingAnchor),
        ])
    }
}

extension MyPickerViewController : UIPickerViewDelegate, UIPickerViewDataSource {
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
        let doc = self.textDocumentProxy
        if let s = doc.documentContextAfterInput {
            doc.adjustTextPosition(byCharacterOffset: s.count)
        }
        delay(0.1) {
            while doc.hasText {
                doc.deleteBackward()
            }
            doc.insertText(self.pep[row])
        }
    }
}

// just proving that this override is possible and actually works
// we are asked for our own input accessory view controller
// so input accessory view can be managed by one
class MyTextField : UITextField {
    var _iavc : UIInputViewController?
    override var inputAccessoryViewController: UIInputViewController? {
        get {
            return self._iavc
        }
        set {
            self._iavc = newValue
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tf: UITextField!
    let pvc = MyPickerViewController()
    let mdbvc = MyDoneButtonViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tf.inputView = self.pvc.inputView
        (self.tf as! MyTextField).inputAccessoryViewController = mdbvc
        self.mdbvc.delegate = self // for dismissal
    }
    
}


