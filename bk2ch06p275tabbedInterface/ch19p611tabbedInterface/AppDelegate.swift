

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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window!.tintColor = UIColor.red() // prove that bar item tint color is inherited
        
        UITabBarItem.appearance().setTitleTextAttributes([
            NSFontAttributeName:UIFont(name:"Avenir-Heavy", size:14)!
            ],
            for:[])
        
//        UIFont.familyNames()
//            .map{UIFont.fontNamesForFamilyName($0 as String)}.map(println)

        
        let ding = UIFont(name:"ZapfDingbatsITC", size:40)!
        let r = UIGraphicsImageRenderer(size:CGSize(100,40))
        let im = r.image {
            _ in
            let s = "\u{2713}"
            let p = NSMutableParagraphStyle()
            p.alignment = .right
            s.draw(in:CGRect(0,0,100,40),
                   withAttributes:[
                    NSFontAttributeName:ding,
                    NSParagraphStyleAttributeName:p,
                    NSForegroundColorAttributeName:UIColor.red()])
        }

        
//        UIGraphicsBeginImageContextWithOptions(CGSize(100,40), false, 0)
//        let s = "\u{2713}"
//        let p = NSMutableParagraphStyle()
//        p.alignment = .right
//        s.draw(in:CGRect(0,0,100,40),
//            withAttributes:[
//                NSFontAttributeName:ding,
//                NSParagraphStyleAttributeName:p,
//                NSForegroundColorAttributeName:UIColor.red()])
//        let im = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
        
        UITabBar.appearance().selectionIndicatorImage = im
        
        
        return true
    }
    
}

