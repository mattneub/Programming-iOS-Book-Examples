

import UIKit
import CoreText

class ViewController : UIViewController {
    
    /*
    Works fine in iOS 7, but as of this moment it breaks in iOS 8
    (and so does Apple's own DownloadFont example)
*/
    
    @IBOutlet var lab : UILabel!
    
    func doDynamicType(n:NSNotification!) {
        self.lab.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doDynamicType(nil)
        
        // see http://support.apple.com/kb/HT5484 (? needs revision? is there a more recent version?)
        let name = "LucidaGrande"
        let size : CGFloat = 12
        let f = UIFont(name:name, size:size)
        if f != nil {
            self.lab.font = f
            println("already installed")
            return
        }
        println("attempting to download font")
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
                    let d = (prog as NSDictionary)
                    let cur : AnyObject = d.objectForKey(kCTFontDescriptorMatchingPercentage)
                    if let cur = cur as? NSObject {
                        NSLog("progress: %@%%", cur)
                    }
                case .DidFinishDownloading:
                    NSLog("%@", "downloading did finish")
                case .DidFailWithError:
                    NSLog("%@", "downloading failed")
                case .DidFinish:
                    NSLog("%@", "matching did finish")
                    dispatch_async(dispatch_get_main_queue(), {
                        let f = UIFont(name:name, size:size)
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
