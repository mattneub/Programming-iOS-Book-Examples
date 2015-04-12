
import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    var pep : [String]!
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame:UIScreen.mainScreen().bounds)
        
        self.setUpPageViewController()
        
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        return true
    }
    
    func application(application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func setUpPageViewController() {
        self.pep = ["Manny", "Moe", "Jack"]
        // make a page view controller
        let pvc = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pvc.restorationIdentifier = "pvc"
        
        // give it an initial page
        let page = Pep(pepBoy: self.pep[0])
        pvc.setViewControllers([page], direction: .Forward, animated: false, completion: nil)
        // give it a data source
        pvc.dataSource = self
        // stick it in the interface
        self.window!.rootViewController = pvc
        
        let proxy = UIPageControl.appearance()
        proxy.pageIndicatorTintColor = UIColor.redColor().colorWithAlphaComponent(0.6)
        proxy.currentPageIndicatorTintColor = UIColor.redColor()
        proxy.backgroundColor = UIColor.yellowColor()
        
    }
    
    // like the previous example, but this time we don't encode any Pep here at all!
    // we just make it possible for Pep to encode itself more or less automatically
    // to do this, first we restore the whole interface;
    // all restorable view controllers already exist, so we just point to them
    
    func application(application: UIApplication, viewControllerWithRestorationIdentifierPath ip: [AnyObject], coder: NSCoder) -> UIViewController? {
        let last = (ip as NSArray).lastObject as! String
        var result : UIViewController? = nil
        switch last {
        case "pvc":
            result = self.window!.rootViewController
        case "pep":
            result = (self.window!.rootViewController as! UIPageViewController).viewControllers[0] as? UIViewController
        default: break
        }
        println("app delegate providing view controller \(result)")
        return result
    }
    
    // encode current pep boy as in the previous example...
    // ...not in order to retrieve it later, but in order to make "pvc/pep" a path
    
    func application(application: UIApplication, willEncodeRestorableStateWithCoder coder: NSCoder) {
        let pvc = self.window!.rootViewController as! UIPageViewController
        let pep = pvc.viewControllers[0] as! Pep
        println("app delegate encoding \(pep)")
        coder.encodeObject(pep, forKey:"pep")
    }
    
    // no decode!
    
}

extension AppDelegate : UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let boy = (viewController as! Pep).boy
        let ix = find(self.pep, boy)! + 1
        if ix >= self.pep.count {
            return nil
        }
        return Pep(pepBoy: self.pep[ix])
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let boy = (viewController as! Pep).boy
        let ix = find(self.pep, boy)! - 1
        if ix < 0 {
            return nil
        }
        return Pep(pepBoy: self.pep[ix])
    }
    
    // if these methods are implemented, page indicator appears
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pep.count
    }
    func presentationIndexForPageViewController(pvc: UIPageViewController) -> Int {
        let page = pvc.viewControllers[0] as! Pep
        let boy = page.boy
        return find(self.pep, boy)!
    }
    
}

