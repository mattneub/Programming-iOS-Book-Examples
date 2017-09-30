

import UIKit

class ViewController : UIViewController {
    
    
    /*
    I've also included a font, mostly just to display Xcode 6 new feature
    where you can set the font of something to an included font right in IB
*/
    
    @IBOutlet var lab : UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // see http://support.apple.com/kb/HT5484 (? needs revision? is there a more recent version?)
        let name = "NanumBrush" // another one to try: YuppySC-Regular, also good old LucidaGrande
        let size : CGFloat = 24
        let f : UIFont! = UIFont(name:name, size:size)
        if f != nil {
            self.lab.font = f
            print("already installed")
            return
        }
        print("attempting to download font")
        let desc = UIFontDescriptor(name:name, size:size)
        CTFontDescriptorMatchFontDescriptorsWithProgressHandler(
            [desc] as CFArray, nil, { state, prog in
                switch state {
                case .didBegin:
                    NSLog("%@", "matching did begin")
                case .willBeginDownloading:
                    NSLog("%@", "downloading will begin")
                case .downloading:
                    let d = prog as NSDictionary
                    let key = kCTFontDescriptorMatchingPercentage
                    let cur = d[key] // wow, no cast needed
                    if let cur = cur as? NSNumber {
                        NSLog("progress: %@%%", cur)
                    }
                case .didFinishDownloading:
                    NSLog("%@", "downloading did finish")
                case .didFailWithError:
                    NSLog("%@", "downloading failed")
                case .didFinish:
                    NSLog("%@", "matching did finish")
                    DispatchQueue.main.async {
                        let f : UIFont! = UIFont(name:name, size:size)
                        if f != nil {
                            NSLog("%@ %@", "got the font!", f)
                            self.lab.font = f
                        }
                    }
                default:break
                }
                return true
            })
    }
    
}
