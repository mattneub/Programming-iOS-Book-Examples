
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
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        
        self.window!.tintColor = .red // prove that bar item tint color is inherited
        
        UITabBar.appearance().unselectedItemTintColor = .blue // new in iOS 10
        // interesting: this seems to override my title text attributes for .normal
        
        var which : Int { return 2 }
        switch which {
        case 1:
            // the green is ignored, the blue of unselectedItemTintColor overrides
            UITabBarItem.appearance().setTitleTextAttributes([
                .font:UIFont(name:"Avenir-Heavy", size:14)!,
                .foregroundColor:UIColor.green
                ], for:.normal)
            // I am curious but yellow
            UITabBarItem.appearance().setTitleTextAttributes([
                .font:UIFont(name:"Avenir-Heavy", size:14)!,
                .foregroundColor:UIColor.yellow
                ], for:.selected)
        case 2:
            // huge iOS 13 bug: trying to do this the iOS 13 appearance way...
            // causes the icon to be too low and the text to be curtailed!
            // ok, fixed in iOS 14! what a relief
            let app = UITabBarAppearance()
            app.stackedLayoutAppearance.normal.titleTextAttributes = [
            .font:UIFont(name:"Avenir-Heavy", size:14)!,
            .foregroundColor:UIColor.green
            ]
            app.stackedLayoutAppearance.selected.titleTextAttributes = [
            .font:UIFont(name:"Avenir-Heavy", size:14)!,
            .foregroundColor:UIColor.red
            ]
//            app.inlineLayoutAppearance.normal.titleTextAttributes = [
//                .font:UIFont(name:"Avenir-Heavy", size:14)!,
//                .foregroundColor:UIColor.green
//            ]
//            app.inlineLayoutAppearance.selected.titleTextAttributes = [
//                .font:UIFont(name:"Avenir-Heavy", size:14)!,
//                .foregroundColor:UIColor.red
//            ]
            app.compactInlineLayoutAppearance.normal.titleTextAttributes = [
                .font:UIFont(name:"Avenir-Heavy", size:14)!,
                .foregroundColor:UIColor.green
            ]
            app.compactInlineLayoutAppearance.selected.titleTextAttributes = [
                .font:UIFont(name:"Avenir-Heavy", size:14)!,
                .foregroundColor:UIColor.red
            ]
            // uncomment next lines to see if bug is still there
//            app.stackedItemPositioning = .centered
//            app.stackedItemSpacing = 0
//            app.stackedItemWidth = 50
            UITabBar.appearance().standardAppearance = app
        default:break
        }
        
        
        
        
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

        
        return true
    }



}

