

import UIKit
import AVFoundation

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

class ViewController: UIViewController {

    @IBOutlet var mv : MyMandelbrotView!
    
    @IBAction func doButton (_ sender: Any) {
        self.mv.drawThatPuppy()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.testDispatchGroups()
        // self.test()
        self.testSerial()
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
    
    func test() {
        let outerQueue = DispatchQueue(label: "outer")
        let innerQueue = DispatchQueue(label: "inner")
        let group = DispatchGroup()
        outerQueue.async {
            let series = "123456789"
            for c in series {
                group.enter()
                innerQueue.asyncAfter(deadline: .now() + .milliseconds(Int.random(in: 1...1000))) {
                    print(c, terminator:"")
                    group.leave()
                }
                // comment out this next line for a different result
                group.wait()
            }
            group.notify(queue: DispatchQueue.main) {
                print("\ndone")
            }
        }
    }
    
    func testSerial() {
        let MANDELBROT_STEPS = 1000
        func isInMandelbrotSet(_ re:Float, _ im:Float) -> Bool {
            var fl = true
            var (x, y, nx, ny) : (Float, Float, Float, Float) = (0,0,0,0)
            for _ in 0 ..< MANDELBROT_STEPS {
                nx = x*x - y*y + re
                ny = 2*x*y + im
                if nx*nx + ny*ny > 4 {
                    fl = false
                    break
                }
                x = nx
                y = ny
            }
            return fl
        }
        let outerQueue = DispatchQueue(label: "outer")
        // delete the attributes and see what happens
        let queue = DispatchQueue(label: "queue", attributes: .concurrent)
        outerQueue.async {
            for k in 1...10 {
                queue.async {
                    for i in 1...Int.random(in: 1000...2000) {
                        for j in 1...Int.random(in: 1000...2000) {
                            _ = isInMandelbrotSet(Float(i), Float(j))
                        }
                    }
                    print(k)
                }
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
