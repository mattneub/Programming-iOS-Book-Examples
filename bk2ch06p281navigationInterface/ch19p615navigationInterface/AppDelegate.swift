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



@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        self.window!.tintColor = .orange // gag... Just proving this is inherited
        
        // nav bar is configured (horribly) in the storyboard
        
        // and now for some even more disgusting decoration
        
        return true;
        
        let im = UIImage(named:"linen.png")!
        let sz = CGSize(5,34)
        let r = UIGraphicsImageRenderer(size:sz, format:im.imageRendererFormat)
        let im2 = r.image {
            _ in
            im.draw(at:CGPoint(-55,-55))
        }

//        UIGraphicsBeginImageContextWithOptions(sz, false, 0)
//        im.draw(at:CGPoint(-55,-55))
//        let im2 = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
        
        let im3 = im2.resizableImage(withCapInsets:UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0), resizingMode:.tile)
        UIBarButtonItem.appearance().setBackgroundImage(im3, for:.normal, barMetrics:.default)
        
        
        // if the back button is assigned a background image, the chevron is removed entirely
        // UIBarButtonItem.appearance().setBackButtonBackgroundImage(im3, for: .normal, barMetrics: .default)

        // also, note that if the back button is assigned a background image,
        // it is not vertically resized
        // and if it has an image, that image is resized to fit

        
        
        return true
    }
    
}
