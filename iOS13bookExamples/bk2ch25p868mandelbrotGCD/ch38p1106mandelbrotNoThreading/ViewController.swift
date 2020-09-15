

import UIKit
import AVFoundation

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


struct Oncer2 {
    private static var once : Void = {
        print("I did it once too!")
    }()
    func doThisOnce() {
        _ = type(of:self).once
    }
}
let oncer2 = Oncer2()


class ViewController: UIViewController {

    @IBOutlet var mv : MyMandelbrotView!
    
    @IBAction func doButton (_ sender: Any) {
        self.mv.drawThatPuppy()
    }
    
    struct Oncer {
        private static var once : Void = {
            print("I did it once!")
        }()
        func doThisOnce() {
            _ = type(of:self).once
        }
    }
    let oncer = Oncer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.testOnce()
        // self.testDispatchGroups()
    }
    
    func testOnce() {
        self.oncer.doThisOnce()
        self.oncer.doThisOnce()
        self.oncer.doThisOnce()
        self.oncer.doThisOnce()
        oncer2.doThisOnce()
        oncer2.doThisOnce()
        oncer2.doThisOnce()
        oncer2.doThisOnce()
    }
    
    func testDispatchGroups() {
        DispatchQueue.global(qos: .background).async {
            let queue = DispatchQueue(label:"com.neuburg.groupq", attributes:.concurrent)
            let group = DispatchGroup()
            
            group.enter()
            queue.async {
                delay(Double(arc4random_uniform(10))) {
                    print("finished 1")
                    group.leave()
                }
            }
            
            group.enter()
            queue.async {
                delay(Double(arc4random_uniform(10))) {
                    print("finished 2")
                    group.leave()
                }
            }
            
            group.enter()
            queue.async {
                delay(Double(arc4random_uniform(10))) {
                    print("finished 3")
                    group.leave()
                }
            }
            
            group.notify(queue: DispatchQueue.main) {
                print("All async calls were run!")
            }
            
        }

    }


    
}

// not used, just testing syntax

class AssetTester : NSObject {
    let assetQueue = DispatchQueue(label: "testing.testing")
    func getAssetInternal() -> AVAsset {
        return AVAsset()
    }
    func asset() -> AVAsset? {
        var theAsset : AVAsset!
        self.assetQueue.sync { // parentheses to silence overzealous warning
            theAsset = (self.getAssetInternal().copy() as! AVAsset)
        }
        return theAsset
    }
}
