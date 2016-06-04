
import UIKit
import Photos
func delay(_ delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

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
        PHPhotoLibrary.shared().register(self)
        self.setUpInterface()
    }

    func determineStatus() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            return true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization() {_ in}
            return false
        case .restricted:
            return false
        case .denied:
            let alert = UIAlertController(title: "Need Authorization", message: "Wouldn't you like to authorize this app to use your Photos library?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                _ in
                let url = NSURL(string:UIApplicationOpenSettingsURLString)!
                UIApplication.shared().open(url)
            }))
            self.present(alert, animated:true)
            return false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = self.determineStatus()
        NSNotificationCenter.default().addObserver(self, selector: #selector(determineStatus), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.default().removeObserver(self)
    }
    
    func tryToAddInitialPage() {
        self.modelController = ModelController()
        if let dvc = self.modelController.viewController(at:0, storyboard: self.storyboard!) {
            let viewControllers = [dvc]
            self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: false)
            self.pageViewController!.dataSource = self.modelController
        }
    }
    
    func setUpInterface() {
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.pageViewController!.dataSource = nil
        self.tryToAddInitialPage() // if succeeds, will set data source for real
        
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        self.pageViewController!.view.frame = self.view.bounds
        self.pageViewController!.didMove(toParentViewController: self)
    }
}

extension RootViewController : PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInfo: PHChange) {
        if let ci = changeInfo.changeDetails(for:unsafeBitCast(self.modelController.recentAlbums, to:PHFetchResult<AnyObject>.self)) {
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
}

extension RootViewController {
    @IBAction func doVignetteButton(_ sender: AnyObject) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }

        if let dvc = self.pageViewController?.viewControllers?[0] as? DataViewController {
            dvc.doVignette()
        }
    }
}


