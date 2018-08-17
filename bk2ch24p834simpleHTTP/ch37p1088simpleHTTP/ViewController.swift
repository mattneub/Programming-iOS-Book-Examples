

import UIKit

class ViewController: UIViewController {

    @IBOutlet var iv : UIImageView!
    @IBOutlet weak var prog: UIProgressView!
    
    @IBAction func doSimpleHTTP (_ sender: Any!) {
        self.iv.image = nil
        let s = "https://www.apeth.net/matt/images/phoenixnewest.jpg"
        let url = URL(string:s)!
        let session = URLSession.shared
        let task = session.downloadTask(with:url) { fileURL, resp, err in
            print("here")
            // this was a test to see: if we resume on a queue, are we called back on the same queue?
            // the test failed
            // dispatchPrecondition(condition: .onQueue(DispatchQueue.global(qos: .background)))
            print("still here")
            guard err == nil else {
                print(err as Any)
                return
            }
            let status = (resp as! HTTPURLResponse).statusCode
            print("response status: \(status)")
            guard status == 200 else {
                print(status)
                return
            }
            if let url = fileURL, let d = try? Data(contentsOf:url) {
                let im = UIImage(data:d)
                DispatchQueue.main.async {
                    self.iv.image = im
                    print("done")
                }
            }
        }
        // just demonstrating syntax
        task.priority = URLSessionTask.defaultPriority
        // new iOS 11 feature
        if #available(iOS 11.0, *) {
            self.prog.observedProgress = task.progress
        }
        // let's try something I didn't know you could do....
        DispatchQueue.global(qos: .background).async {
            task.resume()
            dispatchPrecondition(condition: .onQueue(DispatchQueue.global(qos: .background)))
        }
    }
    
    // -------------------
    
    // just showing some "return a value" strategies — this has gone into Appendix C
    // this can never work
    func doSomeNetworking() -> UIImage? {
        let s = "https://www.apeth.net/matt/images/phoenixnewest.jpg"
        let url = URL(string:s)!
        var image : UIImage? = nil
        let session = URLSession.shared
        let task = session.downloadTask(with:url) { loc, resp, err in
            if let loc = loc, let d = try? Data(contentsOf:loc) {
                let im = UIImage(data:d)
                image = im
            }
        }
        task.resume()
        return image
    }
    // but this can
    func doSomeNetworking2(callBackWithImage: @escaping (UIImage?) -> Void) {
        let s = "https://www.apeth.net/matt/images/phoenixnewest.jpg"
        let url = URL(string:s)!
        let session = URLSession.shared
        let task = session.downloadTask(with:url) { loc, resp, err in
            if let loc = loc, let d = try? Data(contentsOf:loc) {
                let im = UIImage(data:d)
                callBackWithImage(im)
            }
        }
        task.resume()
    }
    func test() {
        doSomeNetworking2 { im in
            DispatchQueue.main.async {
                self.iv.image = im
            }
        }
    }

    
}
