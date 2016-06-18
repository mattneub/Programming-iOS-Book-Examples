
import UIKit
//func imageOfSize(_ size:CGSize, _ opaque:Bool = false, _ closure:() -> ()) -> UIImage {
//    UIGraphicsBeginImageContextWithOptions(size, opaque, 0)
//    closure()
//    let result = UIGraphicsGetImageFromCurrentImageContext()!
//    UIGraphicsEndImageContext()
//    return result
//}

func imageOfSize(_ size:CGSize, closure:() -> ()) -> UIImage {
    let r = UIGraphicsImageRenderer(size:size)
    return r.image {
        _ in closure()
    }
}


extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}



class MyCoolActivity : UIActivity {
    var items : [AnyObject]?
    var image : UIImage
    
    override init() {
        let idiom = UIScreen.main().traitCollection.userInterfaceIdiom
        var scale : CGFloat = (idiom == .pad ? 76 : 60) - 10
        let im = UIImage(named:"sunglasses.png")!
        let largerSize = fmax(im.size.height, im.size.width)
        scale /= largerSize
        let sz = CGSize(im.size.width*scale, im.size.height*scale)
        self.image = imageOfSize(sz) {
            im.draw(in:CGRect(origin: CGPoint(), size: sz))
        }
        super.init()
    }
    
    override class func activityCategory() -> UIActivityCategory {
        return .action // the default
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
    
    override func canPerform(withActivityItems activityItems: [AnyObject]) -> Bool {
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
    
    override func prepare(withActivityItems activityItems: [AnyObject]) {
        print("cool prepare \(activityItems)")
        self.items = activityItems
    }
    
    override func perform() {
        print("cool performing \(self.items)")
        self.activityDidFinish(true)
    }
    
    deinit {
        print("cool activity dealloc")
    }

}
