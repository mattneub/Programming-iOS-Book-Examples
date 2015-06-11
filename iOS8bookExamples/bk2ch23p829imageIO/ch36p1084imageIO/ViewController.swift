
import UIKit
import ImageIO
import MobileCoreServices

class ViewController: UIViewController {

    @IBOutlet var iv : UIImageView!
    
    @IBAction func doButton (sender:AnyObject!) {
        let url = NSBundle.mainBundle().URLForResource("colson", withExtension: "jpg")
        let src = CGImageSourceCreateWithURL(url, nil)
        let result = CGImageSourceCopyPropertiesAtIndex(src, 0, nil) as [NSObject:AnyObject]
        println(result)
        // just proving it really is a dictionary
        print(result[kCGImagePropertyPixelWidth as String]!); print(" by "); println(result[kCGImagePropertyPixelHeight as String]!)
    }

    @IBAction func doButton2 (sender:AnyObject!) {
        let url = NSBundle.mainBundle().URLForResource("colson", withExtension: "jpg")
        let src = CGImageSourceCreateWithURL(url, nil)
        let scale = UIScreen.mainScreen().scale
        let w = self.iv.bounds.width * scale
        let d : [NSObject:AnyObject] = [
            kCGImageSourceShouldAllowFloat : true,
            kCGImageSourceCreateThumbnailWithTransform : true,
            kCGImageSourceCreateThumbnailFromImageAlways : true,
            kCGImageSourceThumbnailMaxPixelSize : w
        ]
        let imref = CGImageSourceCreateThumbnailAtIndex(src, 0, d)
        let im = UIImage(CGImage: imref, scale: scale, orientation: .Up)!
        self.iv.image = im
        println(im)
        println(im.size)
    }

    @IBAction func doButton3 (sender:AnyObject!) {
        let url = NSBundle.mainBundle().URLForResource("colson", withExtension: "jpg")
        let src = CGImageSourceCreateWithURL(url, nil)
        let fm = NSFileManager()
        let suppurl = fm.URLForDirectory(.ApplicationSupportDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true, error: nil)!
        let tiff = suppurl.URLByAppendingPathComponent("mytiff.tiff")
        let dest = CGImageDestinationCreateWithURL(tiff, kUTTypeTIFF, 1, nil)
        CGImageDestinationAddImageFromSource(dest, src, 0, nil)
        let ok = CGImageDestinationFinalize(dest)
        if ok {
            println("tiff image written to disk")
        } else {
            println("something went wrong")
        }
    }

    
}
