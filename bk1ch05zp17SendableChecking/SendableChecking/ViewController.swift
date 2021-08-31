
import UIKit

// showing some of the tricks for getting Sendable checking to calm down

extension URL: @unchecked Sendable {} // *
extension Data: @unchecked Sendable {} // *

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Task { [self] in // *
            try await self.fetchManyURLs()
        }
    }
    func download(url: URL) async throws -> Data {
        return Data()
    }
    func fetchManyURLs() async throws -> [URL:Data] {
        let urls: [URL] = [URL(string: "https://www.apeth.com")!]
        return try await withThrowingTaskGroup(of: [URL:Data].self) { group in
            var result = [URL:Data]()
            for url in urls {
                group.addTask { [self] in // *
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

