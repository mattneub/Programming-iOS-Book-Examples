
import UIKit
import ImageIO
import MobileCoreServices

class ViewController: UIViewController {

    @IBOutlet var iv : UIImageView!
    
    @IBAction func doButton (_ sender:AnyObject!) {
        let url = Bundle.main.urlForResource("colson", withExtension: "jpg")!
        let src = CGImageSourceCreateWithURL(url, nil)!
        let result = CGImageSourceCopyPropertiesAtIndex(src, 0, nil)! as [NSObject:AnyObject]
        print(result)
        // just proving it really is a dictionary
        let width = result[kCGImagePropertyPixelWidth] as! CGFloat
        let height = result[kCGImagePropertyPixelHeight] as! CGFloat
        print("\(width) by \(height)")
    }

    @IBAction func doButton2 (_ sender:AnyObject!) {
        let url = Bundle.main.urlForResource("colson", withExtension: "jpg")!
        let src = CGImageSourceCreateWithURL(url, nil)!
        let scale = UIScreen.main.scale
        let w = self.iv.bounds.width * scale
        let d : [NSObject:AnyObject] = [
            kCGImageSourceShouldAllowFloat : true,
            kCGImageSourceCreateThumbnailWithTransform : true,
            kCGImageSourceCreateThumbnailFromImageAlways : true,
            kCGImageSourceThumbnailMaxPixelSize : w
        ]
        let imref = CGImageSourceCreateThumbnailAtIndex(src, 0, d)!
        let im = UIImage(cgImage: imref, scale: scale, orientation: .up)
        self.iv.image = im
        print(im)
        print(im.size)
    }

    @IBAction func doButton3 (_ sender:AnyObject!) {
        let url = Bundle.main.urlForResource("colson", withExtension: "jpg")!
        let src = CGImageSourceCreateWithURL(url, nil)!
        let fm = FileManager()
        let suppurl = try! fm.urlForDirectory(.applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let tiff = try! suppurl.appendingPathComponent("mytiff.tiff")
        let dest = CGImageDestinationCreateWithURL(tiff, kUTTypeTIFF, 1, nil)!
        CGImageDestinationAddImageFromSource(dest, src, 0, nil)
        let ok = CGImageDestinationFinalize(dest)
        if ok {
            print("tiff image written to disk")
        } else {
            print("something went wrong")
        }
    }

    
}
