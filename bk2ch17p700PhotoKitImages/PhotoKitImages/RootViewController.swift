
import UIKit
import Photos

class RootViewController: UIViewController {
                            
    var pageViewController: UIPageViewController?
    var modelController : ModelController!
    
    /*
    Because authorization is asynchronous, we face an interesting problem:
    if we get the authorization dialog, even if the user accepts,
    our setup code will have returned without succeededing in getting an initial image
    
    So what we'd like to do in that case is try again;
    thus we want to be notified if authorization happens.
    The way to detect that is to observe that we now have images where previously we had none
*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
        self.setUpInterface()
    }
    
    func tryToAddInitialPage() {
        self.modelController = ModelController()
        if let dvc = self.modelController.viewControllerAtIndex(0, storyboard: self.storyboard) {
            let viewControllers: NSArray = [dvc]
            self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
            self.pageViewController!.dataSource = self.modelController
        }
    }
    
    func setUpInterface() {
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController!.dataSource = nil
        self.tryToAddInitialPage() // if succeeds, will set data source for real
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController!.view)
        self.pageViewController!.view.frame = self.view.bounds
        self.pageViewController!.didMoveToParentViewController(self)
    }
}

extension RootViewController : PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(changeInfo: PHChange!) {
        let ci = changeInfo.changeDetailsForFetchResult(self.modelController.recentAlbums)
        // if what just happened is: we went from nil to results (because user granted permission)...
        // then start over
        let oldResult = ci.fetchResultBeforeChanges
        if oldResult.firstObject == nil {
            let newResult = ci.fetchResultAfterChanges
            if newResult.firstObject != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.tryToAddInitialPage()
                }
            }
        }
    }
}


