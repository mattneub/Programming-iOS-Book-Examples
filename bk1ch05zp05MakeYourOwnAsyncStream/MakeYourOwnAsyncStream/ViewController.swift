

import UIKit

class TextFieldSelectionChangeStreamer: NSObject, UITextFieldDelegate {
    var values : AsyncStream<UITextField>
    var continuation : AsyncStream<UITextField>.Continuation?
    override init() {
        var myContinuation : AsyncStream<UITextField>.Continuation?
        self.values = AsyncStream { continuation in
            myContinuation = continuation
        }
        super.init()
        self.continuation = myContinuation
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.continuation?.yield(textField)
    }
}


class ViewController: UIViewController {
    let textFieldSelectionChangeStreamer = TextFieldSelectionChangeStreamer()
    @IBOutlet var textField : UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField?.delegate = self.textFieldSelectionChangeStreamer
        Task {
            for await textField in self.textFieldSelectionChangeStreamer.values {
                print(textField.text ?? "")
            }
        }
    }


}

