
import UIKit
func imageOfSize(size:CGSize, _ opaque:Bool = false, _ closure:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, opaque, 0)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}

class MyCoolActivity : UIActivity {
    var items : [AnyObject]?
    var image : UIImage
    
    override init() {
        let idiom = UIScreen.mainScreen().traitCollection.userInterfaceIdiom
        var scale : CGFloat = (idiom == .Pad ? 76 : 60) - 10
        let im = UIImage(named:"sunglasses.png")!
        let largerSize = fmax(im.size.height, im.size.width)
        scale /= largerSize
        let sz = CGSizeMake(im.size.width*scale, im.size.height*scale)
        self.image = imageOfSize(sz) {
            im.drawInRect(CGRect(origin: CGPoint(), size: sz))
        }
        super.init()
    }
    
    override class func activityCategory() -> UIActivityCategory {
        return .Action // the default
    }
    
    override func activityType() -> String? {
        return "com.neuburg.matt.coolActivity"
    }
    
    override func activityTitle() -> String? {
        return "Be Cool"
    }
    
    override func activityImage() -> UIImage? {
        return self.image
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        print("cool can perform \(activityItems)")
        for obj in activityItems {
            if obj is String {
                print("returning true")
                return true
            }
        }
        print("returning false")
        return false
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        print("cool prepare \(activityItems)")
        self.items = activityItems
    }
    
    override func performActivity() {
        print("cool performing \(self.items)")
        self.activityDidFinish(true)
    }
    
    deinit {
        print("cool activity dealloc")
    }

}