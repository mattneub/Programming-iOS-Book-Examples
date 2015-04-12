
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
        return true // *
    }
    
    func application(application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true // *
    }
    
    func setUpPageViewController() {
        self.pep = ["Manny", "Moe", "Jack"]
        // make a page view controller
        let pvc = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
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
    
    // all we really need to save is the current boy name
    
    func application(application: UIApplication, willEncodeRestorableStateWithCoder coder: NSCoder) {
        let pvc = self.window!.rootViewController as! UIPageViewController
        let boy = (pvc.viewControllers[0] as! Pep).boy
        coder.encodeObject(boy, forKey:"boy")
    }
    
    func application(application: UIApplication, didDecodeRestorableStateWithCoder coder: NSCoder) {
        let boy: AnyObject? = coder.decodeObjectForKey("boy")
        if let boy = boy as? String {
            let pvc = self.window!.rootViewController as! UIPageViewController
            let pep = Pep(pepBoy: boy)
            pvc.setViewControllers([pep], direction: .Forward, animated: false, completion: nil)
        }
    }
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

