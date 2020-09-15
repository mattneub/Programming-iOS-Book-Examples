import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        let arr = CIFilter.filterNames(inCategories:nil)
        for name in arr {
            let f = CIFilter(name: name)
            if f != nil {
                print(name)
            } else {
                print(name, "NIL")
            }
        }
        
        return true
    }
}
