

import UIKit
import os

// trying to show that although `print` output is not sent to console...
// ... in Xcode-independent release build, it is still _evaluated_
// that is the problem discussed at https://stackoverflow.com/a/38335438/341994


let mylog = OSLog(subsystem: "com.neuburg.matt", category: "testing")

class ViewController: UIViewController {

    @IBAction func doButton(_ sender: Any) {
        print("printing")
        NSLog("%@","logging")
        print(self.test())
    }
    
    func test() -> String {
        let fm = FileManager.default
        let docs = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        print(docs)
        let url = docs.appendingPathComponent("test.txt")
        try! "tested".write(to: url, atomically: true, encoding: .utf8)
        os_log("oslog")
        return "tested"
    }


}

