
import UIKit

class ViewController : UIViewController, UIPageViewControllerDataSource {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let pvc = segue.destinationViewController as! UIPageViewController
        pvc.dataSource = self
        let page = MyPage()
        page.num = 1
        pvc.setViewControllers([page], direction:.Forward, animated:false, completion:nil)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let page = viewController as! MyPage
        let num = page.num
        if num == 10 { return nil }
        let page2 = MyPage()
        page2.num = num+1
        return page2
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let page = viewController as! MyPage
        let num = page.num
        if num == 1 { return nil }
        let page2 = MyPage()
        page2.num = num-1
        return page2
    }
    
    // this bug appears to be fixed in iOS 8! here's what it was:
    // start at page 1
    // click the button to jump to page 8
    // now swipe backwards to see the previous page
    // it is page 1!
    // that's the bug; the page view controller has not updated its internal state

    func jumpTo8(sender:AnyObject?) {
        let page = MyPage()
        page.num = 8
        let pvc = self.childViewControllers[0] as! UIPageViewController
        pvc.setViewControllers([page], direction: .Forward, animated: true, completion: {
            _ in
            // workaround:
            /*
            dispatch_async(dispatch_get_main_queue()) {
                // pvc.setViewControllers([page], direction: .Forward, animated: false, completion: nil)
            }
            */
            })
    }
    
}
