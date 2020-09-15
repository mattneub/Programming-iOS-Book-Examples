

import UIKit

class RootViewController: UIViewController, UIPageViewControllerDataSource {
    
    weak var pageViewController : UIPageViewController!
    let pep : [String] = ["Manny", "Moe", "Jack"]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let proxy = UIPageControl.appearance()
        proxy.pageIndicatorTintColor = UIColor.red.withAlphaComponent(0.6)
        proxy.currentPageIndicatorTintColor = .red
        proxy.backgroundColor = .yellow
        
        
        let pvc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pvc.dataSource = self
        self.addChild(pvc)
        self.view.addSubview(pvc.view)
        
        let (_,f) = self.view.bounds.divided(atDistance: 50, from: .minYEdge)
        pvc.view.frame = f
        pvc.view.autoresizingMask = [.flexibleHeight]
        
        pvc.didMove(toParent: self)
        
        let page = Pep(pepBoy: self.pep[0])
        pvc.setViewControllers([page], direction: .forward, animated: false)
        
        self.pageViewController = pvc

    }
    


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
