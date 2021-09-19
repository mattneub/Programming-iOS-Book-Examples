
import UIKit
import MediaPlayer
import Combine

class ViewController: UIViewController {
    

    var which = 2
    
    var observers = Set<NSObject>()
    var storage = Set<AnyCancellable>()
    var pipeline : AnyCancellable?
    var task : Task<(), Never>?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch which {
        case 0:
            print("registering observer")
            let ob = NotificationCenter.default.addObserver(forName: ViewController2.notif, object: nil, queue: nil) { _ in
                print("notification received")
            }
            self.observers.insert(ob as! NSObject)
        case 1:
            print("subscribing with Combine")
            NotificationCenter.default.publisher(for: ViewController2.notif)
                .sink { _ in print("notification received") }
                .store(in: &self.storage)
        case 2:
            print("subscribing with async stream")
            let stream = NotificationCenter.default.notifications(named: ViewController2.notif)
            let task = Task {
                for await _ in stream {
                    print("notification received")
                }
            }
            self.task = task
        default: break
        }
    }

    func test() { // just showing syntax; these are not proper tests, that needs doing
        do {
            let ob = NotificationCenter.default.addObserver(
                forName: .MPMusicPlayerControllerNowPlayingItemDidChange,
                object: nil, queue: nil) { [unowned self] _ in
                    self.updateNowPlayingItem()
                    // ... and so on ...
                }
            self.observers.insert(ob as! NSObject)
            // ...
            for ob in self.observers {
                NotificationCenter.default.removeObserver(ob)
            }
        }
        do {
            self.pipeline = NotificationCenter.default.publisher(
                for: .MPMusicPlayerControllerNowPlayingItemDidChange)
                    .sink { [unowned self] _ in
                        self.updateNowPlayingItem()
                        // ... and so on ...
                    }
            // ...
            self.pipeline?.cancel()
            self.pipeline = nil
        }
        do {
            let stream = NotificationCenter.default.notifications(
                named: .MPMusicPlayerControllerNowPlayingItemDidChange)
            let task = Task {
                for await _ in stream {
                    self.updateNowPlayingItem()
                    // ... and so on ...
                }
            }
            self.task = task
            // ...
            self.task?.cancel()
            self.task = nil
        }
    }
    
    @IBAction func unwind(_:UIStoryboardSegue) {}
    
    @IBAction func unregister (_ sender:Any) {
        print("unregistering")
        for ob in self.observers {
            NotificationCenter.default.removeObserver(ob)
        }
        self.observers.removeAll()
        
        self.storage.removeAll()
        
        self.task?.cancel()
        // don't really need this
        // self.task = nil
    }

    func updateNowPlayingItem() {}

}

