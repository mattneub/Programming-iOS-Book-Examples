

import UIKit
import CoreText

class ViewController : UIViewController {
    
    
    /*
    I've also included a font, mostly just to display Xcode 6 new feature
    where you can set the font of something to an included font right in IB
*/
    
    @IBOutlet var lab : UILabel!
    
    func doDynamicType(n:NSNotification!) {
        self.lab.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doDynamicType(nil)
        
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
            [desc], nil, {
                (state:CTFontDescriptorMatchingState, prog:CFDictionary!) -> Bool in
                switch state {
                case .DidBegin:
                    NSLog("%@", "matching did begin")
                case .WillBeginDownloading:
                    NSLog("%@", "downloading will begin")
                case .Downloading:
                    let d = prog as NSDictionary
                    let key = kCTFontDescriptorMatchingPercentage
                    let cur : AnyObject? = d[key as NSString]
                    if let cur = cur as? NSNumber {
                        NSLog("progress: %@%%", cur)
                    }
                case .DidFinishDownloading:
                    NSLog("%@", "downloading did finish")
                case .DidFailWithError:
                    NSLog("%@", "downloading failed")
                case .DidFinish:
                    NSLog("%@", "matching did finish")
                    dispatch_async(dispatch_get_main_queue(), {
                        let f : UIFont! = UIFont(name:name, size:size)
                        if f != nil {
                            NSLog("%@", "got the font!")
                            self.lab.font = f
                        }
                        })
                default:break
                }
                return true
            })
    }
    
}
