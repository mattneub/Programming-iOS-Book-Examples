
import UIKit

class MyElaborateActivity : UIActivity {
    
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
        return "com.neuburg.matt.elaborateActivity"
    }
    
    override func activityTitle() -> String? {
        return "Elaborate"
    }
    
    override func activityImage() -> UIImage? {
        return self.image
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        print("elaborate can perform \(activityItems)")
        print("returning true")
        return true
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        print("elaborate prepare \(activityItems)")
        self.items = activityItems
    }
    
    override func activityViewController() -> UIViewController? {
        let mvc = MustacheViewController(activity: self, items: self.items!)
        return mvc
    }
    
    deinit {
        print("elaborate activity dealloc")
    }
    
}
