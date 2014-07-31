

import UIKit
import CoreText

class ViewController : UIViewController {
    
    @IBOutlet var lab : UILabel!
    
    func doDynamicType(n:NSNotification!) {
        self.lab.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doDynamicType(nil)
        
        // see http://support.apple.com/kb/HT5484 (? needs revision? is there a more recent version?)
        let name = "AppleGothic-Regular"
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
                    NSLog("progress: %@%%",
                        d[kCTFontDescriptorMatchingPercentage] as String
                    )
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
        /*
        if (state == kCTFontDescriptorMatchingDidBegin) {
        NSLog(@"%@", @"matching did begin");
        }
        else if (state == kCTFontDescriptorMatchingWillBeginDownloading) {
        NSLog(@"%@", @"downloading will begin");
        }
        else if (state == kCTFontDescriptorMatchingDownloading) {
        NSDictionary* d = (__bridge NSDictionary*)prog;
        NSLog(@"progress: %@%%",
        d[(__bridge NSString*)kCTFontDescriptorMatchingPercentage]);
        }
        else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
        NSLog(@"%@", @"downloading did finish");
        }
        else if (state == kCTFontDescriptorMatchingDidFailWithError) {
        NSLog(@"%@", @"downloading failed");
        }
        else if (state == kCTFontDescriptorMatchingDidFinish) {
        NSLog(@"%@", @"matching did finish");
        dispatch_async(dispatch_get_main_queue(), ^{
        UIFont* f = [UIFont fontWithName:name size:size];
        if (f) {
        NSLog(@"%@", @"got the font!");
        self.lab.font = f;
        }
        });
        }
        return (bool)YES;
        });
        */
    }
    
}
