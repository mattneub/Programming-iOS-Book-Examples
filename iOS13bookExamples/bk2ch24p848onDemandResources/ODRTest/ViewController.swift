
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var iv : UIImageView!
    
    var requests = [Set<String>:NSBundleResourceRequest]()

    @IBAction func testForTubby() {
        let im = UIImage(named:"tubby")
        print("tubby is", im as Any)
        let c2 = NSDataAsset(name: "control2")
        print("control2 is", c2 as Any)
        print(Bundle.main.url(forResource: "control", withExtension: "mp3") as Any)
        print(self.requests[["tubby"]]?.bundle.url(forResource: "control", withExtension: "mp3") as Any)
        print("frac is", self.self.requests[["tubby"]]?.progress.fractionCompleted as Any)
    }
    
    // this sort of thing is probably a good idea...
    func ensureAccessToTags(_ tags:Set<String>, andThen f:@escaping ()->()) {
        if self.requests[tags] != nil {
            // we have access already, just do whatever it is
            f()
            return
        }
        // we don't have access; provide it
        requests[tags] = NSBundleResourceRequest(tags: tags)
        requests[tags]!.beginAccessingResources { err in
            guard err == nil else {print(err as Any); return}
            DispatchQueue.main.async {
                f()
            }
        }
    }
    
    @IBAction func startUsingTubby() {
        self.ensureAccessToTags(["tubby"]) {
            print("accessing tubby")
            let im = UIImage(named:"tubby")
            self.iv.image = im
        }
    }
    
    @IBAction func stopUsingTubby() {
        if let req = self.requests[["tubby"]] {
            self.iv.image = nil
            req.endAccessingResources()
            self.requests[["tubby"]] = nil
        }
    }
    
    

}

