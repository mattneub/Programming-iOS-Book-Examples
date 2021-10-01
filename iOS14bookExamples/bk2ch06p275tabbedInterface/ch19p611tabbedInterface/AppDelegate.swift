

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

// proving that you can add your own appearance-compliant properties
class MyView: UIView {
    @objc dynamic var bc : UIColor? {
        set {
            self.backgroundColor = newValue
        }
        get {
            return self.backgroundColor
        }
    }
}

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        self.window!.tintColor = .red // prove that bar item tint color is inherited
        
        UITabBar.appearance().unselectedItemTintColor = .black // new in iOS 10
        // interesting: this seems to override my title text attributes for .normal

        
        UITabBarItem.appearance().setTitleTextAttributes([
            .font:UIFont(name:"Avenir-Heavy", size:14)!,
            .foregroundColor:UIColor.green
            ], for:.normal)
        // I am curious but yellow
        UITabBarItem.appearance().setTitleTextAttributes([
            .font:UIFont(name:"Avenir-Heavy", size:14)!,
            .foregroundColor:UIColor.yellow
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
                    .font:ding,
                    .paragraphStyle:p,
                    .foregroundColor:UIColor.red])
        }
        
        
        UITabBar.appearance().selectionIndicatorImage = im
        
        MyView.appearance().bc = UIColor.green
        
        return true
    }
    
}

