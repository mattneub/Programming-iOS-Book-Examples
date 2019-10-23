import UIKit
import BackgroundTasks

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    let taskid = "com.neuburg.matt.lengthy"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        let v = MyMandelbrotView(frame:CGRect(0,0,500,500))
        let ok = BGTaskScheduler.shared.register(forTaskWithIdentifier: taskid, using: DispatchQueue.global(qos: .background)) { task in
            print("starting background task")
            task.expirationHandler = {
                task.setTaskCompleted(success: false)
            }
            let context = v.makeBitmapContext(size: CGSize(500,500))
            v.draw(center: CGPoint(250,250), bounds: CGRect(0,0,500,500), zoom: 1, context: context)
            print("finished background task")
            task.setTaskCompleted(success: true)
        }
        print("tried to register", ok)
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
//        delay(5) {
//            print(UIApplication.shared.backgroundTimeRemaining, "remaining")
//        }
        let req = BGProcessingTaskRequest(identifier: self.taskid)
        do {
            try BGTaskScheduler.shared.submit(req)
        } catch {
            print(error)
        }
    }
    
    // e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.neuburg.matt.lengthy"]

}

