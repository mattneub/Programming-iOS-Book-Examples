

import UIKit

class ViewController: UIViewController {
    
    // showing how actor reentrancy means you have to be careful about mutable state
    // when the actor says await

    actor MyDownloader {
        var counter = 0
        func download(url: URL) async throws -> Data {
            counter += 1
            let num = counter
            let result = try await URLSession.shared.data(from: url)
            print(num == counter)
            return result.0 // the data
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        let downloader = MyDownloader()
        Task {
            var result = [Data]()
            try await withThrowingTaskGroup(of: Data.self) { group in
                let url1 = URL(string:"https://www.apeth.com/pep/manny.jpg")!
                let url2 = URL(string:"https://www.apeth.com/pep/moe.jpg")!
                let url3 = URL(string:"https://www.apeth.com/pep/jack.jpg")!
                let urls: [URL] = [url1, url2, url3]
                for url in urls {
                    group.addTask {
                        return try await downloader.download(url: url)
                    }
                }
                for try await data in group {
                    result.append(data)
                }
            }
            print(result)
        }
    }





}

