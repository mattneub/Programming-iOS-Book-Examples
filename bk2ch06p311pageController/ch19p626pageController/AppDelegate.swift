
import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    let pep : [String] = ["Manny", "Moe", "Jack"]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        self.window = self.window ?? UIWindow()
        
        self.setUpPageViewController()
        
        self.window!.backgroundColor = .white
        self.window!.makeKeyAndVisible()
        return true
    }
    
    func setUpPageViewController() {
        // make a page view controller - NB try both .pageCurl and .scroll
        let pvc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        // give it an initial page
        let page = Pep(pepBoy: self.pep[0])
        pvc.setViewControllers([page], direction: .forward, animated: false)
        // give it a data source
        pvc.dataSource = self
        // put its view into the interface
        self.window!.rootViewController = pvc
        
        let proxy = UIPageControl.appearance()
        proxy.pageIndicatorTintColor = UIColor.red.withAlphaComponent(0.6)
        proxy.currentPageIndicatorTintColor = .red
        proxy.backgroundColor = .yellow
        
        self.messWithGestureRecognizers(pvc) // uncomment to try it
    }
    
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
    
    // =======
    
    func messWithGestureRecognizers(_ pvc:UIPageViewController) {
        if pvc.transitionStyle == .pageCurl { // does nothing for .scroll
            for g in pvc.gestureRecognizers {
                if let g = g as? UITapGestureRecognizer {
                    g.numberOfTapsRequired = 2
                }
            }
        }
        else { // not needed for .pageCurl
            NotificationCenter.default.addObserver(forName:Pep.tap, object: nil, queue: .main) { n in
                let g = n.object as! UIGestureRecognizer
                let which = g.view!.tag
                let vc0 = pvc.viewControllers![0]
                guard let vc = (which == 0 ? self.pageViewController(pvc, viewControllerBefore: vc0) : self.pageViewController(pvc, viewControllerAfter: vc0))
                    else {return}
                let dir : UIPageViewController.NavigationDirection = which == 0 ? .reverse : .forward
                UIApplication.shared.beginIgnoringInteractionEvents()
                pvc.setViewControllers([vc], direction: dir, animated: true) {
                    _ in
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
    }
}
