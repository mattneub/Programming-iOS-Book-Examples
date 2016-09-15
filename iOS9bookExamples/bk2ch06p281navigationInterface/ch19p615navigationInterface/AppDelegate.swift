import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window!.tintColor = UIColor.orangeColor() // gag... Just proving this is inherited
        
        // nav bar is configured (horribly) in the storyboard
        
        // and now for some even more disgusting decoration
        
        let im = UIImage(named:"linen.png")!
        let sz = CGSizeMake(5,34)
        UIGraphicsBeginImageContextWithOptions(sz, false, 0)
        im.drawAtPoint(CGPointMake(-55,-55))
        let im2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let im3 = im2.resizableImageWithCapInsets(UIEdgeInsetsMake(0,0,0,0), resizingMode:.Tile)
        UIBarButtonItem.appearance().setBackgroundImage(im3, forState:.Normal, barMetrics:.Default)
        
        
        // if the back button is assigned a background image, the chevron is removed entirely
        // UIBarButtonItem.appearance().setBackButtonBackgroundImage(im3, forState: .Normal, barMetrics: .Default)

        // also, note that if the back button is assigned a background image,
        // it is not vertically resized
        // and if it has an image, that image is resized to fit

        
        
        return true
    }
    
}
