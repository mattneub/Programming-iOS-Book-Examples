

import UIKit

class ViewController: UIViewController {

    @IBOutlet var iv : UIImageView!
    
    @IBAction func doSimpleHTTP (_ sender: Any!) {
        self.iv.image = nil
        let s = "https://www.apeth.net/matt/images/phoenixnewest.jpg"
        let url = URL(string:s)!
        let session = URLSession.shared
        let task = session.downloadTask(with:url) { loc, resp, err in
            print("here")
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
            if let loc = loc, let d = try? Data(contentsOf:loc) {
                let im = UIImage(data:d)
                DispatchQueue.main.async {
                    self.iv.image = im
                    print("done")
                }
            }
        }
        // just demonstrating syntax
        task.priority = URLSessionTask.defaultPriority
        task.resume()
    }
    
    // -------------------
    
    // just showing some "return a value" strategies
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
