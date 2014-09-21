

import UIKit

@UIApplicationMain class AppDelegate : UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        self.window!.rootViewController = UIViewController()
        let mainview = self.window!.rootViewController!.view
        
        let which = 1
        switch which {
        case 1:
            let v1 = UIView(frame:CGRectMake(113, 111, 132, 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            let v2 = UIView(frame:v1.bounds.rectByInsetting(dx: 10, dy: 10))
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            mainview.addSubview(v1)
            v1.addSubview(v2)
            
            v1.transform = CGAffineTransformMakeRotation(45 * CGFloat(M_PI)/180.0)
            println(v1.frame)
            
        case 2:
            let v1 = UIView(frame:CGRectMake(113, 111, 132, 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            let v2 = UIView(frame:v1.bounds.rectByInsetting(dx: 10, dy: 10))
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            mainview.addSubview(v1)
            v1.addSubview(v2)
            
            v1.transform = CGAffineTransformMakeScale(1.8, 1)
            
        case 3:
            let v1 = UIView(frame:CGRectMake(20, 111, 132, 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            let v2 = UIView(frame:v1.bounds)
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            mainview.addSubview(v1)
            v1.addSubview(v2)
            
            v2.transform = CGAffineTransformMakeTranslation(100, 0)
            v2.transform = CGAffineTransformRotate(v2.transform, 45 * CGFloat(M_PI)/180.0)
            
        case 4:
            let v1 = UIView(frame:CGRectMake(20, 111, 132, 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            let v2 = UIView(frame:v1.bounds)
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            mainview.addSubview(v1)
            v1.addSubview(v2)
            
            v2.transform = CGAffineTransformMakeRotation(45 * CGFloat(M_PI)/180.0)
            v2.transform = CGAffineTransformTranslate(v2.transform, 100, 0)
            
        case 5: // same as case 4 but using concat
            let v1 = UIView(frame:CGRectMake(20, 111, 132, 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            let v2 = UIView(frame:v1.bounds)
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            mainview.addSubview(v1)
            v1.addSubview(v2)
            
            let r = CGAffineTransformMakeRotation(45 * CGFloat(M_PI)/180.0)
            let t = CGAffineTransformMakeTranslation(100, 0)
            v2.transform = CGAffineTransformConcat(t,r) // not r,t
            
        case 6:
            let v1 = UIView(frame:CGRectMake(20, 111, 132, 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            let v2 = UIView(frame:v1.bounds)
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            mainview.addSubview(v1)
            v1.addSubview(v2)

            let r = CGAffineTransformMakeRotation(45 * CGFloat(M_PI)/180.0)
            let t = CGAffineTransformMakeTranslation(100, 0)
            v2.transform = CGAffineTransformConcat(t,r)
            v2.transform = CGAffineTransformConcat(CGAffineTransformInvert(r), v2.transform)
            
        case 7:
            let v1 = UIView(frame:CGRectMake(113, 111, 132, 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            let v2 = UIView(frame:v1.bounds.rectByInsetting(dx: 10, dy: 10))
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            mainview.addSubview(v1)
            v1.addSubview(v2)

            v1.transform = CGAffineTransformMake(1, 0, -0.2, 1, 0, 0)
            
        default: break
        }
        
        
        
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        return true
    }
    
}
