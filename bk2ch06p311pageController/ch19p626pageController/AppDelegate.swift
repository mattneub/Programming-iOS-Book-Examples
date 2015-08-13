
import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    var pep : [String]!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow()
        
        self.setUpPageViewController()
        
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        return true
    }
    
    func setUpPageViewController() {
        self.pep = ["Manny", "Moe", "Jack"]
        // make a page view controller - NB try both .PageCurl and .Scroll
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
        
        // self.messWithGestureRecognizers(pvc) // uncomment to try it
    }
    
}

extension AppDelegate : UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let boy = (viewController as! Pep).boy
        let ix = self.pep.indexOf(boy)! + 1
        if ix >= self.pep.count {
            return nil
        }
        return Pep(pepBoy: self.pep[ix])
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let boy = (viewController as! Pep).boy
        let ix = self.pep.indexOf(boy)! - 1
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
        let page = pvc.viewControllers![0] as! Pep
        let boy = page.boy
        return self.pep.indexOf(boy)!
    }
    
    // =======
    
    func messWithGestureRecognizers(pvc:UIPageViewController) {
        if pvc.transitionStyle == .PageCurl { // does nothing for .Scroll
            for g in pvc.gestureRecognizers {
                if let g = g as? UITapGestureRecognizer {
                    g.numberOfTapsRequired = 2
                }
            }
        }
        else { // not needed for .PageCurl
            NSNotificationCenter.defaultCenter().addObserverForName("tap", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
                n in
                let g = n.object as! UIGestureRecognizer
                let which = g.view!.tag
                let vc0 = pvc.viewControllers![0]
                let vc = (which == 0 ? self.pageViewController(pvc, viewControllerBeforeViewController: vc0) : self.pageViewController(pvc, viewControllerAfterViewController: vc0))
                if vc == nil {
                    return
                }
                let dir : UIPageViewControllerNavigationDirection = which == 0 ? .Reverse : .Forward
                UIApplication.sharedApplication().beginIgnoringInteractionEvents()
                pvc.setViewControllers([vc!], direction: dir, animated: true, completion: {
                    _ in
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                })
            })
        }
    }
}
