

import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window!.tintColor = UIColor.redColor() // prove that bar item tint color is inherited
        
        UITabBarItem.appearance().setTitleTextAttributes([
            NSFontAttributeName:UIFont(name:"Avenir-Heavy", size:14)!
            ],
            forState:.Normal)
        
//        UIFont.familyNames()
//            .map{UIFont.fontNamesForFamilyName($0 as String)}.map(println)

        
        let ding = UIFont(name:"ZapfDingbatsITC", size:40)!
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(100,40), false, 0)
        let s = "\u{2713}"
        let p = NSMutableParagraphStyle()
        p.alignment = .Right
        s.drawInRect(CGRectMake(0,0,100,40),
            withAttributes:[
                NSFontAttributeName:ding,
                NSParagraphStyleAttributeName:p,
                NSForegroundColorAttributeName:UIColor.redColor()])
        let im = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UITabBar.appearance().selectionIndicatorImage = im
        
        
        return true
    }
    
}

