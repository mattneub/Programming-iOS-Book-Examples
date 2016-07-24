
import UIKit

extension Notification.Name {
    static let tap = Notification.Name("tap")
}

let pepboy : UIImage = #imageLiteral(resourceName: "pepBoy") // just showing an image literal

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    var pep : [String]!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow()
        
        self.setUpPageViewController()
        
        self.window!.backgroundColor = UIColor.white()
        self.window!.makeKeyAndVisible()
        return true
    }
    
    func setUpPageViewController() {
        self.pep = ["Manny", "Moe", "Jack"]
        // make a page view controller - NB try both .PageCurl and .Scroll
        let pvc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        // give it an initial page
        let page = Pep(pepBoy: self.pep[0])
        pvc.setViewControllers([page], direction: .forward, animated: false)
        // give it a data source
        pvc.dataSource = self
        // stick it in the interface
        self.window!.rootViewController = pvc
        
        let proxy = UIPageControl.appearance()
        proxy.pageIndicatorTintColor = UIColor.red().withAlphaComponent(0.6)
        proxy.currentPageIndicatorTintColor = UIColor.red()
        proxy.backgroundColor = UIColor.yellow()
        
        // self.messWithGestureRecognizers(pvc) // uncomment to try it
    }
    
}

extension AppDelegate : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let boy = (viewController as! Pep).boy
        let ix = self.pep.index(of:boy)! + 1
        if ix >= self.pep.count {
            return nil
        }
        return Pep(pepBoy: self.pep[ix])
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let boy = (viewController as! Pep).boy
        let ix = self.pep.index(of:boy)! - 1
        if ix < 0 {
            return nil
        }
        return Pep(pepBoy: self.pep[ix])
    }
    
    // if these methods are implemented, page indicator appears
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pep.count
    }
    func presentationIndex(for pvc: UIPageViewController) -> Int {
        let page = pvc.viewControllers![0] as! Pep
        let boy = page.boy
        return self.pep.index(of:boy)!
    }
    
    // =======
    
    func messWithGestureRecognizers(_ pvc:UIPageViewController) {
        if pvc.transitionStyle == .pageCurl { // does nothing for .scroll
            for g in pvc.gestureRecognizers {
                if let g = g as? UITapGestureRecognizer {
                    g.numberOfTapsRequired = 2
                }
            }
        }
        else { // not needed for .PageCurl
            NotificationCenter.default.addObserver(forName:.tap, object: nil, queue: .main, using: {
                n in
                let g = n.object as! UIGestureRecognizer
                let which = g.view!.tag
                let vc0 = pvc.viewControllers![0]
                let vc = (which == 0 ? self.pageViewController(pvc, viewControllerBefore: vc0) : self.pageViewController(pvc, viewControllerAfter: vc0))
                if vc == nil {
                    return
                }
                let dir : UIPageViewControllerNavigationDirection = which == 0 ? .reverse : .forward
                UIApplication.shared().beginIgnoringInteractionEvents()
                pvc.setViewControllers([vc!], direction: dir, animated: true) {
                    _ in
                    UIApplication.shared().endIgnoringInteractionEvents()
                }
            })
        }
    }
}
