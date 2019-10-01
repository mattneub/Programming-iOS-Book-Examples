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
        
        var im = UIImage(named:"linen.png")!
        let sz = CGSize(5,34)
        let r = UIGraphicsImageRenderer(size:sz, format:im.imageRendererFormat)
        im = r.image {
            _ in im.draw(at:CGPoint(-55,-55))
        }

        im = im.resizableImage(withCapInsets:UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0), resizingMode:.tile)
        // UIBarButtonItem.appearance().setBackgroundImage(im3, for:.normal, barMetrics:.default)
        // do that with the new UIBarButtonItemAppearance
        
        let app = UIBarButtonItemAppearance()
        app.normal.backgroundImage = im
        let navbarapp = UINavigationBarAppearance()
        navbarapp.configureWithOpaqueBackground()
        navbarapp.backgroundColor = .blue // no effect
        navbarapp.buttonAppearance = app
        let back = UIBarButtonItemAppearance()
        back.normal.backgroundImage = UIImage() // prevent back button item
        navbarapp.backButtonAppearance = back
        UINavigationBar.appearance().standardAppearance = navbarapp
                

        // also, note that if the back button is assigned a background image,
        // it is not vertically resized
        // and if it has an image, that image is resized to fit

        // just testing
        
        
        
        do {
            let navbarapp = UINavigationBarAppearance()
            navbarapp.configureWithOpaqueBackground()
            navbarapp.backgroundColor = .blue // okay, that works
            // so this _is_ the scroll edge appearance even though there is no scroll edge
            UINavigationBar.appearance().scrollEdgeAppearance = navbarapp
        }
        
        
        return true
    }
    
}
