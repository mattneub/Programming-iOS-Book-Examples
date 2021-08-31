
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // task initializer
        let url = URL(string: "https://www.apeth.com/pep/manny.jpg")!
        Task {
            do {
                let data = try await self.download(url: url)
                // do something with data
                print(data)
            } catch {
                print(error)
            }
        }
    }
    
    // first try: okay, we can download, but how do we do something with result?
    func download(url: URL) -> Data {
        var result: Data = Data()
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                // can't return from here
                // return data
                // okay, let's use something we _can_ return
                result = data
            }
        }
        task.resume()
        return result // the trouble is, it's always empty
    }
    
    // solution: use a completion handler
    func download2(url: URL, completionHandler: @escaping (Data) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                completionHandler(data)
            } else {
                // but what if there's an error? this is not a very good solution
                completionHandler(Data())
            }
        }
        task.resume()
    }
    
    // well, we could trying throwing
    func download3(url: URL, completionHandler: @escaping (Data) -> ()) throws {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                completionHandler(data)
            } else if let error = error {
                // throw error // nope, compiler error; can't throw here
            } else {
                fatalError("Should be impossible to get here")
            }
        }
        task.resume()
    }
    
    // the only way: _return" the error in the completion handler
    typealias MyCompletionHandler = (Result<Data, Error>) -> ()
    func download4(url: URL, completionHandler: @escaping MyCompletionHandler) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                completionHandler(.success(data))
            } else if let error = error {
                completionHandler(.failure(error))
            } else {
                fatalError("Should be impossible to get here")
            }
        }
        task.resume()
    }
    
    // the async/await solution
    func download(url: URL) async throws -> Data {
        let result = try await URLSession.shared.data(from: url)
        return result.0 // the data
    }

    // let's say we are forced to keep the completion handler solution
    // then we can wrap it in an async/await approach
    func myDownload(url:URL) async throws -> Data {
        return try await withUnsafeThrowingContinuation { continuation in
            download4(url:url) { result in
                continuation.resume(with: result)
            }
        }
    }

}

