
import UIKit
func imageOfSize(size:CGSize, closure:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
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
        println("cool can perform \(activityItems)")
        for obj in activityItems {
            if obj is String {
                println("returning true")
                return true
            }
        }
        println("returning false")
        return false
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        println("cool prepare \(activityItems)")
        self.items = activityItems
    }
    
    override func performActivity() {
        println("cool performing \(self.items)")
        self.activityDidFinish(true)
    }
    
    deinit {
        println("cool activity dealloc")
    }

}