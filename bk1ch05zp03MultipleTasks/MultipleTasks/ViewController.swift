

import UIKit

extension Task where Success == Never, Failure == Never {
    static func sleep(_ seconds:Double) async {
        await self.sleep(UInt64(seconds * 1_000_000_000))
    }
    static func sleepThrowing(_ seconds:Double) async throws {
        try await self.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}

actor Waiter {
    func wait1(_ i:Int) async {
        print("starting wait1", i)
        await Task.sleep(1.0)
        print("middle wait1", i)
        await Task.sleep(1.0)
        print("end wait1", i)
    }
    func wait2(_ i:Int) async {
        print("starting wait2", i)
        await Task.sleep(1.0)
        print("middle wait2", i)
        await Task.sleep(1.0)
        print("end wait2", i)
    }
}

actor MyDownloader {
    func download(url: URL) async throws -> Data {
        print("called with", url)
        let result = try await URLSession.shared.data(from: url)
        print("returning data from", url)
        return result.0 // the data
    }
    func fetchManyURLs1() async throws -> [Data] {
        let url1 = URL(string:"https://www.apeth.com/pep/manny.jpg")!
        let url2 = URL(string:"https://www.apeth.com/pep/moe.jpg")!
        let urls: [URL] = [url1, url2]
        var result = [Data]()
        try await withThrowingTaskGroup(of: Data.self) { group in
            for url in urls {
                group.addTask {
                    return try await self.download(url: url)
                }
            }
            for try await data in group {
                result.append(data)
            }
        }
        return result
    }
    
    func fetchManyURLs2() async throws -> [URL:Data] {
        let url1 = URL(string:"https://www.apeth.com/pep/manny.jpg")!
        let url2 = URL(string:"https://www.apeth.com/pep/moe.jpg")!
        let urls: [URL] = [url1, url2]
        var result = [URL:Data]()
        try await withThrowingTaskGroup(of: [URL:Data].self) { group in
            for url in urls {
                group.addTask {
                    return [url: try await self.download(url: url)]
                }
            }
            for try await d in group {
                result.merge(d) {cur,_ in cur}
            }
        }
        return result
    }

    func fetchManyURLs3() async throws -> [URL:Data] {
        let url1 = URL(string:"https://www.apeth.com/pep/manny.jpg")!
        let url2 = URL(string:"https://www.apeth.com/pep/moe.jpg")!
        let urls: [URL] = [url1, url2]
        return try await withThrowingTaskGroup(
            of: [URL:Data].self,
            returning: [URL:Data].self) { group in
                var result = [URL:Data]()
                for url in urls {
                    group.addTask {
                        return [url: try await self.download(url: url)]
                    }
                }
                for try await d in group {
                    result.merge(d) {cur,_ in cur}
                }
                return result
        }
    }


    func fetchManyURLs() async throws -> [URL:Data] {
        let url1 = URL(string:"https://www.apeth.com/pep/manny.jpg")!
        let url2 = URL(string:"https://www.apeth.com/pep/moe.jpg")!
        let urls: [URL] = [url1, url2]
        return try await withThrowingTaskGroup(
            of: [URL:Data].self) { group in
                var result = [URL:Data]()
                for url in urls {
                    group.addTask {
                        return [url: try await self.download(url: url)]
                    }
                }
                print(Thread.isMainThread)
                for try await d in group {
                    result.merge(d) {cur,_ in cur}
                }
                return result
        }
    }
    
}

class ViewController: UIViewController {
    var which = 0
    let downloader = MyDownloader()
    override func viewDidLoad() {
        super.viewDidLoad()
        switch which {
        case 0:
            Task {
                let result = try await self.downloader.fetchManyURLs()
                print(result)
            }
        case 1:
            Task {
                let result = try await self.fetchTwoURLs()
                print(result)
            }
        case 2:
            Task {
                let result = try await self.fetchTwoURLs2()
                print(result)
            }
        case 3:
            Task {
                let result = try await self.fetchTwoURLs3()
                print(result)
            }
        default: break
        }
    }
    
    // this two Task approach actually is legal!
    // the problem is that it isn't structured
    // so that cancel has no effect because the outer task is not a parent
    func fetchTwoURLs() async throws -> (Data, Data) {
        let overall = Task { () throws -> (Data, Data) in
            let url1 = URL(string:"https://www.apeth.com/pep/manny.jpg")!
            let url2 = URL(string:"https://www.apeth.com/pep/moe.jpg")!
            let t1 = Task {
                return try await self.downloader.download(url: url1)
            }
            let t2 = Task {
                return try await self.downloader.download(url: url2)
            }
            return (try await t1.value, try await t2.value)
        }
        await Task.sleep(0.01)
        // overall.cancel()
        return try await overall.value
    }

    // async let version
    func fetchTwoURLs2() async throws -> (Data, Data) {
        let url1 = URL(string:"https://www.apeth.com/pep/manny.jpg")!
        let url2 = URL(string:"https://www.apeth.com/pep/moe.jpg")!
        async let d1 = self.downloader.download(url: url1)
        async let d2 = self.downloader.download(url: url2)
        return try await (d1, d2)
    }
    
    // "unfolded" async let
    func fetchTwoURLs3() async throws -> (Data, Data) {
        let url1 = URL(string:"https://www.apeth.com/pep/manny.jpg")!
        let url2 = URL(string:"https://www.apeth.com/pep/moe.jpg")!
        async let d1 = { () async throws -> Data in
            print("start d1")
            let result = try await self.downloader.download(url: url1)
            print("end d1")
            return result
        }()
        async let d2 = { () async throws -> Data in
            print("start d2")
            let result = try await self.downloader.download(url: url2)
            print("end d2")
            return result
        }()
        return try await (d1, d2)
    }



}

