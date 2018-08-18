
import UIKit

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
    var items : [Any]?
    var image : UIImage
    
    override init() {
        let idiom = UIScreen.main.traitCollection.userInterfaceIdiom
        var scale : CGFloat = (idiom == .pad ? 76 : 60) - 10
        let im = UIImage(named:"sunglasses.png")!
        let largerSize = fmax(im.size.height, im.size.width)
        scale /= largerSize
        let sz = CGSize(im.size.width*scale, im.size.height*scale)
        let r = UIGraphicsImageRenderer(size:sz, format:im.imageRendererFormat)
        self.image = r.image { _ in
            im.draw(in:CGRect(origin: .zero, size: sz))
        }
        super.init()
    }
    
    override class var activityCategory : UIActivity.Category {
        return .action // the default
    }
    
    override var activityType : UIActivity.ActivityType { // *
        return UIActivity.ActivityType("com.neuburg.matt.coolActivity") // *
    }
    
    override var activityTitle : String? {
        return "Be Cool"
    }
    
    override var activityImage : UIImage? {
        return self.image
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
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
    
    override func prepare(withActivityItems activityItems: [Any]) {
        print("cool prepare \(activityItems)")
        self.items = activityItems
    }
    
    override func perform() {
        print("cool performing \(self.items as Any)")
        self.activityDidFinish(true)
    }
    
    deinit {
        print("cool activity dealloc")
    }

}
