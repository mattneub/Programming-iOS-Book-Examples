
import UIKit

class MyElaborateActivity : UIActivity {
    
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
    
    override var activityType : UIActivity.ActivityType? {
        return UIActivity.ActivityType("com.neuburg.matt.elaborateActivity")
    }
    
    override var activityTitle : String? {
        return "Elaborate"
    }
    
    override var activityImage : UIImage? {
        return self.image
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        print("elaborate can perform \(activityItems)")
        print("returning true")
        return true
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        print("elaborate prepare \(activityItems)")
        self.items = activityItems
    }
    
    override var activityViewController : UIViewController? {
        let mvc = MustacheViewController(activity: self, items: self.items!)
        return mvc
    }
    
    deinit {
        print("elaborate activity dealloc")
    }
    
}
