
import UIKit

class ViewController: UIViewController {
    
    var tubbyRequest : NSBundleResourceRequest?
    @IBOutlet var iv : UIImageView!

    @IBAction func testForTubby() {
        let im = UIImage(named:"tubby")
        print("tubby is", im as Any)
        let c2 = NSDataAsset(name: "control2")
        print("control2 is", c2 as Any)
        print(Bundle.main.url(forResource: "control", withExtension: "mp3") as Any)
        print(tubbyRequest?.bundle.url(forResource: "control", withExtension: "mp3") as Any)
        print("frac is", self.tubbyRequest?.progress.fractionCompleted as Any)
    }
    
    @IBAction func startUsingTubby() {
        guard self.tubbyRequest == nil else {return}
        self.tubbyRequest = NSBundleResourceRequest(tags: ["tubby"])
        self.tubbyRequest!.addObserver(self, forKeyPath: #keyPath(NSBundleResourceRequest.progress.fractionCompleted), options:[.new], context: nil)
        self.tubbyRequest!.beginAccessingResources { err in
            guard err == nil else {print(err as Any); return}
            DispatchQueue.main.async {
                let im = UIImage(named:"tubby")
                self.iv.image = im
            }
        }
    }
    
    @IBAction func stopUsingTubby() {
        guard self.tubbyRequest != nil else {return}
        self.iv.image = nil
        self.tubbyRequest!.endAccessingResources()
        self.tubbyRequest!.removeObserver(self, forKeyPath: #keyPath(NSBundleResourceRequest.progress.fractionCompleted))
        self.tubbyRequest = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print(change as Any)
    }
    

}

