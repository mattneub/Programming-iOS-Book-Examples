

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let im = UIImage(named:"oneBlueCircle.png")
        let sz = CGSize(width: 16, height: 16)
        let r = UIGraphicsImageRenderer(size: sz)
        let im2 = r.image {_ in
            im?.draw(in: CGRect(origin: .zero, size: sz))
        }
        tf.leftView = UIImageView(image:im2)
        tf.leftViewMode = .always
        tf.leftViewMode = .whileEditing
        tf.leftViewMode = .unlessEditing
        tf.clearButtonMode = .whileEditing
        
        // tf.keyboardType = .numberPad
    }


}

