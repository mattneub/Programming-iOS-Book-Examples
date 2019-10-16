
import UIKit
import ImageIO
import MobileCoreServices

//// temporary workaround from Joe Groff at Apple
//extension CFString: Hashable {
//    public var hashValue: Int {
//        return Int(bitPattern: CFHash(self))
//    }
//    public static func ==(a: CFString, b: CFString) -> Bool {
//        return CFEqual(a, b)
//    }
//}


class ViewController: UIViewController {

    @IBOutlet var iv : UIImageView!
    
    @IBAction func doButton (_ sender: Any!) {
        let url = Bundle.main.url(forResource:"colson", withExtension: "jpg")!
        let opts : [AnyHashable:Any] = [
            kCGImageSourceShouldCache : false
        ]
        let src = CGImageSourceCreateWithURL(url as CFURL, opts as CFDictionary)!
        let d = CGImageSourceCopyPropertiesAtIndex(src, 0, opts as CFDictionary) as! [AnyHashable:Any] // :) works because CFString is now AnyHashable
        print(d)
        // just proving it really is a dictionary
        let width = d[kCGImagePropertyPixelWidth] as! CGFloat
        let height = d[kCGImagePropertyPixelHeight] as! CGFloat
        print("\(width) by \(height)")
        
        // another way; no one in his right mind would do this, though
        do {
            let result = CGImageSourceCopyPropertiesAtIndex(src, 0, opts as CFDictionary)!
            let key = kCGImagePropertyPixelWidth // CFString
            let p1 = Unmanaged.passUnretained(key).toOpaque() // UnsafeMutableRawPointer
            let p2 = CFDictionaryGetValue(result, p1) // UnsafeRawPointer
            let n = Unmanaged<CFNumber>.fromOpaque(p2!).takeUnretainedValue() // CFNumber
            var width : CGFloat = 0
            CFNumberGetValue(n, .cgFloatType, &width) // width is now 640.0
            print(width)
        }
    }

    @IBAction func doButton2 (_ sender: Any!) {
        let url = Bundle.main.url(forResource:"colson", withExtension: "jpg")!
        var opts : [AnyHashable:Any] = [
            kCGImageSourceShouldCache : false
        ]
        let src = CGImageSourceCreateWithURL(url as CFURL, opts as CFDictionary)!
        let scale = UIScreen.main.scale
        let w = self.iv.bounds.width * scale
        opts = [
            kCGImageSourceShouldAllowFloat : true,
            kCGImageSourceCreateThumbnailWithTransform : true,
            kCGImageSourceCreateThumbnailFromImageAlways : true,
            kCGImageSourceShouldCacheImmediately : true,
            kCGImageSourceThumbnailMaxPixelSize : w
        ]
        let imref = CGImageSourceCreateThumbnailAtIndex(src, 0, opts as CFDictionary)!
        let im = UIImage(cgImage: imref, scale: scale, orientation: .up)
        self.iv.image = im
        print(im)
        print(im.size)
    }

    @IBAction func doButton3 (_ sender: Any!) {
        let url = Bundle.main.url(forResource:"colson", withExtension: "jpg")!
        let opts : [AnyHashable:Any] = [
            kCGImageSourceShouldCache : false
        ]
        let src = CGImageSourceCreateWithURL(url as CFURL, opts as CFDictionary)!
        let fm = FileManager.default
        let suppurl = try! fm.url(for:.applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let tiff = suppurl.appendingPathComponent("mytiff.tiff")
        let dest = CGImageDestinationCreateWithURL(tiff as CFURL, kUTTypeTIFF, 1, nil)!
        CGImageDestinationAddImageFromSource(dest, src, 0, nil)
        let ok = CGImageDestinationFinalize(dest)
        if ok {
            print("tiff image written to disk")
            print(tiff)
        } else {
            print("something went wrong")
        }
    }

    
}
