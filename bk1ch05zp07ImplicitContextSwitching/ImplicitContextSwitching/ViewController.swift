
import UIKit

// show that a group task's subtask may run on a background thread
// even if the subtask is created on the main thread

class ViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Thread.isMainThread) // true
        Task {
            print(Thread.isMainThread) // true
            try await fetchManyURLs()
        }
    }
    func download(url: URL) async throws -> Data {
        return Data()
    }
    @discardableResult
    func fetchManyURLs() async throws -> [URL:Data] {
        let urls: [URL] = [URL(string: "https://www.apeth.com")!]
        return try await withThrowingTaskGroup(of: [URL:Data].self) { group in
            var result = [URL:Data]()
            print(Thread.isMainThread) // true
            UIImageView().image = UIImage() // ok
            for url in urls {
                group.addTask {
                    print(Thread.isMainThread) // false
                    // UIImageView().image = UIImage() // not ok
                    return [url: try await self.download(url: url)]
                }
            }
            for try await d in group {
                result.merge(d) {cur,_ in cur}
            }
            return result
        }
    }
    


}

