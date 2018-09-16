
import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    let pep = ["Manny", "Moe", "Jack"]
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        self.window = self.window ?? UIWindow()
        
        self.setUpPageViewController()
        
        self.window!.backgroundColor = .white
        self.window!.makeKeyAndVisible()
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func setUpPageViewController() {
        // make a page view controller
        let pvc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pvc.restorationIdentifier = "pvc"
        
        // give it an initial page
        let page = Pep(pepBoy: self.pep[0])
        pvc.setViewControllers([page], direction: .forward, animated: false)
        // give it a data source
        pvc.dataSource = self
        // stick it in the interface
        self.window!.rootViewController = pvc
        
        let proxy = UIPageControl.appearance()
        proxy.pageIndicatorTintColor = UIColor.red.withAlphaComponent(0.6)
        proxy.currentPageIndicatorTintColor = .red
        proxy.backgroundColor = .yellow
        
    }
    
    // like the previous example, but this time we don't encode any Pep here at all!
    // we just make it possible for Pep to encode itself more or less automatically
    // to do this, first we restore the whole interface;
    // all restorable view controllers already exist, so we just point to them
    
    func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath ip: [String], coder: NSCoder) -> UIViewController? {
        let last = ip.last!
        var result : UIViewController? = nil
        switch last {
        case "pvc":
            result = self.window!.rootViewController
        case "pep":
            result = (self.window!.rootViewController as! UIPageViewController).viewControllers![0]
        default: break
        }
        print("app delegate providing view controller \(result as Any)")
        return result
    }
    
    // encode current pep boy as in the previous example...
    // ...not in order to retrieve it later, but in order to make "pvc/pep" a path
    
    func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder) {
        let pvc = self.window!.rootViewController as! UIPageViewController
        let pep = pvc.viewControllers![0] as! Pep
        print("app delegate encoding \(pep)")
        coder.encode(pep, forKey:"pep")
    }
    
    // no decode!
    
}

extension AppDelegate : UIPageViewControllerDataSource {
    func pageViewController(_ pvc: UIPageViewController, viewControllerAfter vc: UIViewController) -> UIViewController? {
        let boy = (vc as! Pep).boy
        let ix = self.pep.firstIndex(of:boy)! + 1
        if ix >= self.pep.count {
            return nil
        }
        return Pep(pepBoy: self.pep[ix])
    }
    func pageViewController(_ pvc: UIPageViewController, viewControllerBefore vc: UIViewController) -> UIViewController? {
        let boy = (vc as! Pep).boy
        let ix = self.pep.firstIndex(of:boy)! - 1
        if ix < 0 {
            return nil
        }
        return Pep(pepBoy: self.pep[ix])
    }
    
    // if these methods are implemented, page indicator appears
    
    func presentationCount(for pvc: UIPageViewController) -> Int {
        return self.pep.count
    }
    func presentationIndex(for pvc: UIPageViewController) -> Int {
        let page = pvc.viewControllers![0] as! Pep
        let boy = page.boy
        return self.pep.firstIndex(of:boy)!
    }
    
}

