

import UIKit

class TextFieldSelectionChangeStreamer: NSObject, UITextFieldDelegate {
    var values : AsyncStream<UITextField>
    var continuation : AsyncStream<UITextField>.Continuation?
    override init() {
        var myContinuation : AsyncStream<UITextField>.Continuation?
        self.values = AsyncStream { continuation in
            myContinuation = continuation
            // I also tried to set the `onTermination` handler but couldn't; filed a bug
            // ooo, Tyler Prevost has a workaround (improved by Doug Gregor at bugs.swift.org):
            // https://stackoverflow.com/questions/69047723/cant-set-asyncstream-ontermination-handler
            continuation.onTermination = { @Sendable term in
                print("terminated!")
            }
            // but not fixed in RC
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
    var task : Task<Void, Never>?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField?.delegate = self.textFieldSelectionChangeStreamer
        let task = Task {
            for await textField in self.textFieldSelectionChangeStreamer.values {
                print(textField.text ?? "")
            }
            // let's unroll that so we can see what's actually happening
//            var iter = self.textFieldSelectionChangeStreamer.values.makeAsyncIterator()
//            for _ in 1...Int.max {
//                if let tf = await iter.next() {
//                    print(tf.text ?? "")
//                } else {
//                    print("I got nil")
//                    break
//                }
//            }
        }
        self.task = task
    }
    // prove that an async stream is self-cancelling
    @IBAction func doCancel (_ sender:Any) {
        self.task?.cancel()
    }



}

