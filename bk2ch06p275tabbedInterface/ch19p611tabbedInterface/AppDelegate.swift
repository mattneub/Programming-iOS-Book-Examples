

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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        
        self.window!.tintColor = .red // prove that bar item tint color is inherited
        
        UITabBarItem.appearance().setTitleTextAttributes([
            NSFontAttributeName:UIFont(name:"Avenir-Heavy", size:14)!,
            NSForegroundColorAttributeName:UIColor.green
            ], for:.normal)
        // I am curious but yellow
        UITabBarItem.appearance().setTitleTextAttributes([
            NSFontAttributeName:UIFont(name:"Avenir-Heavy", size:14)!,
            NSForegroundColorAttributeName:UIColor.yellow
            ], for:.selected)

        
        
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
                    NSForegroundColorAttributeName:UIColor.red])
        }
        
        
        UITabBar.appearance().selectionIndicatorImage = im
        
        
        return true
    }
    
}

